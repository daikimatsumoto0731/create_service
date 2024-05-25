# frozen_string_literal: true

require 'google/cloud/vision'

class EventsController < ApplicationController
  before_action :set_vegetable, only: [:update_sowing_date]

  def index
    @selected_vegetable = params[:selected_vegetable]&.downcase
    handle_vegetable_selection
    set_template
  end

  def advice
    @event = Event.find_by(id: params[:id])
    if @event
      render_advice_partial
    else
      render json: { error: 'Event not found' }, status: :not_found
    end
  end

  def update_sowing_date
    update_vegetable_sowing_date
  end

  def new_analyze_image
    # ページの初期表示用
  end

  def analyze_image
    image = params[:image]
    vegetable_name = params[:vegetable_name]

    if image && vegetable_name.present?
      image_path = image.tempfile.path
      Rails.logger.info "Image path: #{image_path}"

      begin
        # 一時ファイルに認証情報を書き込む
        credentials_path = "/tmp/google_application_credentials.json"
        File.open(credentials_path, 'w') do |file|
          file.write(ENV['GOOGLE_APPLICATION_CREDENTIALS_JSON'])
        end

        # Google Cloud Vision APIのクライアントを作成
        vision = Google::Cloud::Vision.image_annotator do |config|
          config.credentials = credentials_path
        end

        response = vision.label_detection image: image_path
        if response && response.responses && !response.responses.empty?
          labels = response.responses[0].label_annotations.map(&:description)
          Rails.logger.info "Labels detected: #{labels.join(', ')}"

          @care_guide = PerenualApiClient.fetch_species_care_guide(vegetable_name)
          if @care_guide && @care_guide['data']
            @care_guide['data'].each do |guide|
              if guide['section']
                guide['section'].each do |section|
                  if section['description']
                    original_description = section['description']
                    Rails.logger.info "Original text encoding: #{original_description.encoding}"
                    translated_text = LibreTranslate.translate(original_description)
                    Rails.logger.info "Translated text encoding: #{translated_text.encoding}"
                    section['original_description'] = original_description.force_encoding('UTF-8')
                    section['translated_description'] = translated_text.force_encoding('UTF-8')
                  end
                end
              else
                Rails.logger.error "No 'section' key in guide: #{guide}"
              end
            end
            @labels = labels
            @vegetable_status = determine_vegetable_status(labels)
          else
            Rails.logger.error "No 'data' key in care_guide: #{@care_guide}"
            @care_guide = nil
            @labels = []
            @vegetable_status = nil
          end
        else
          Rails.logger.error "No labels were detected."
          @labels = []
          @care_guide = nil
          @vegetable_status = nil
        end
      rescue StandardError => e
        Rails.logger.error "Failed to analyze image: #{e.message}"
        flash[:alert] = "画像の分析に失敗しました。エラー: #{e.message}"
        redirect_to new_analyze_image_path and return
      ensure
        # 一時ファイルを削除
        File.delete(credentials_path) if File.exist?(credentials_path)
      end
    else
      flash[:alert] = "画像または野菜の名前が提供されていません。"
      redirect_to new_analyze_image_path and return
    end

    render 'analyze_image'
  end 

  private

  def set_vegetable
    @vegetable = Vegetable.find_by(id: params[:vegetable_id])
    unless @vegetable
      redirect_to(events_path, alert: 'Vegetable not found')
    end
  end

  def handle_vegetable_selection
    if @selected_vegetable.present?
      @vegetable = Vegetable.find_by('lower(name) = ?', @selected_vegetable)
      unless @vegetable
        flash[:alert] = "#{@selected_vegetable} に該当する野菜は見つかりませんでした。"
        redirect_to events_path
      else
        @events = @vegetable.events.order(sort_events_query)
      end
    end
  end

  def sort_events_query
    Arel.sql("CASE WHEN name = '種まき' THEN 0 ELSE 1 END, start_date ASC")
  end

  def set_template
    template_name = @vegetable ? @selected_vegetable : 'default'
    render template: "events/#{template_name}"
  end

  def render_advice_partial
    vegetable_name = @event.vegetable.name.downcase
    partial_name = map_event_name_to_partial(@event.name, vegetable_name)
    render partial: "events/#{partial_name}", locals: { event: @event }, layout: false
  end

  def map_event_name_to_partial(event_name, vegetable_name)
    event_key = {
      '種まき' => 'seed_sowing',
      '発芽期間' => 'germination_period',
      '間引き・雑草抜き・害虫駆除' => 'thinning_weeding_pest_control',
      '収穫期間' => 'harvesting_period'
    }[event_name]
    "advice_#{vegetable_name}_#{event_key}"
  end

  def update_vegetable_sowing_date
    sowing_date = Date.parse(params[:sowing_date])
    ActiveRecord::Base.transaction do
      if @vegetable.update(sowing_date: sowing_date)
        @vegetable.update_related_event_dates
        flash[:notice] = '種まき日を更新しました。'
        redirect_to events_path(selected_vegetable: @vegetable.name.downcase)
      else
        flash[:alert] = '種まき日の更新に失敗しました。'
        redirect_to events_path(selected_vegetable: @vegetable.name.downcase)
      end
    rescue StandardError => e
      flash[:alert] = "更新中にエラーが発生しました: #{e.message}"
      redirect_to events_path(selected_vegetable: @vegetable.name.downcase)
    end
  end

  # analyze_image メソッド内で直接処理を行う
  def determine_vegetable_status(labels)
    # 野菜の状態を初期化
    vegetable_status = {}

    # ラベルに含まれるキーワードを元に野菜の状態を推測
    labels.each do |label|
      if label.downcase.include?('healthy')
        vegetable_status[:status] = '健康的な状態です'
      elsif label.downcase.include?('disease') || label.downcase.include?('pest')
        vegetable_status[:status] = '病気や害虫の影響を受けている可能性があります'
      elsif label.downcase.include?('ripe') || label.downcase.include?('harvest')
        vegetable_status[:status] = '収穫の時期に近づいています'
      elsif label.downcase.include?('dry') || label.downcase.include?('wilting') || label.downcase.include?('yellowing')
        vegetable_status[:status] = '水分不足の可能性があります。十分な水やりを行いましょう。'
      elsif label.downcase.include?('overripe') || label.downcase.include?('rotten')
        vegetable_status[:status] = '過熟や腐敗の可能性があります。早めに収穫しましょう。'
      elsif label.downcase.include?('underripe') || label.downcase.include?('immature')
        vegetable_status[:status] = '未熟な状態です。収穫の時期を待ちましょう。'
      elsif label.downcase.include?('flowering') || label.downcase.include?('blossom')
        vegetable_status[:status] = '花が咲いています。収穫の準備が進んでいます。'
      elsif label.downcase.include?('fruiting') || label.downcase.include?('bearing fruit')
        vegetable_status[:status] = '実がついています。収穫の時期です。'
      elsif label.downcase.include?('weed') || label.downcase.include?('grass')
        vegetable_status[:status] = '雑草が生えています。間引きや雑草取りを行いましょう。'
      elsif label.downcase.include?('insect') || label.downcase.include?('bug')
        vegetable_status[:status] = '害虫が見られます。害虫駆除を行いましょう。'
      elsif label.downcase.include?('drought') || label.downcase.include?('dry soil')
        vegetable_status[:status] = '干ばつの可能性があります。十分な水を与えましょう。'
      elsif label.downcase.include?('fungal') || label.downcase.include?('mold')
        vegetable_status[:status] = 'カビが生えています。風通しの良い環境を保ちましょう。'
      elsif label.downcase.include?('nutrient deficiency') || label.downcase.include?('yellow leaves')
        vegetable_status[:status] = '栄養不足の兆候が見られます。肥料を追加しましょう。'
      elsif label.downcase.include?('overwatering') || label.downcase.include?('waterlogged')
        vegetable_status[:status] = '過剰な水やりの影響が見られます。水はけを良くするために土を乾燥させましょう。'
      elsif label.downcase.include?('stunted growth') || label.downcase.include?('small size')
        vegetable_status[:status] = '成長が停滞しています。栄養不足や環境の問題が考えられます。'
      elsif label.downcase.include?('sunburn') || label.downcase.include?('burnt leaves')
        vegetable_status[:status] = '日焼けが見られます。直射日光を避け、日陰に移動させましょう。'
      elsif label.downcase.include?('overgrown') || label.downcase.include?('too large')
        vegetable_status[:status] = '過剰成長しています。間引きを行いましょう。'
      elsif label.downcase.include?('undergrown') || label.downcase.include?('too small')
        vegetable_status[:status] = '成長が遅れています。十分な日光や栄養を与えましょう。'
      elsif label.downcase.include?('viral infection') || label.downcase.include?('virus')
        vegetable_status[:status] = 'ウイルス感染の兆候が見られます。感染した植物を早めに隔離しましょう。'
      elsif label.downcase.include?('inappropriate temperature') || label.downcase.include?('temperature stress')
        vegetable_status[:status] = '温度が適切でない可能性があります。適切な温度設定を確認しましょう。'
      else
        vegetable_status[:status] = 'その他の状態です。詳細を確認してください。'
      end
    end

    # 野菜の状態を返す
    vegetable_status
  end
end
