# frozen_string_literal: true

require 'google/cloud/vision'

class EventsController < ApplicationController
  before_action :set_vegetable, only: [:show, :update_sowing_date]
  before_action :set_event, only: [:destroy]

  def show
    @selected_vegetable = params[:selected_vegetable]
    @sowing_date = params[:sowing_date]
    @vegetable = Vegetable.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: Event.where(vegetable_id: @vegetable.id).to_json(only: [:id, :title, :start_date, :end_date, :color]) }
    end
  end
  
  def index
    events = Event.where(vegetable_id: params[:vegetable_id])
    render json: events.to_json(only: [:id, :title, :start_date, :end_date, :color])
  end

  def create
    event = Event.new(event_params)
    if event.save
      render json: event, status: :created
    else
      render json: event.errors, status: :unprocessable_entity
    end
  end

  def destroy
    event = Event.find(params[:id])
    event.destroy
    head :no_content
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
  
      translated_vegetable_name = translate_vegetable_name(vegetable_name)
      Rails.logger.info "Translated vegetable name: #{translated_vegetable_name}"
  
      credentials = JSON.parse(ENV['GOOGLE_APPLICATION_CREDENTIALS_JSON'])
      vision = Google::Cloud::Vision.image_annotator do |config|
        config.credentials = credentials
      end
  
      response = vision.label_detection image: image_path
      if response && response.responses && !response.responses.empty?
        labels = response.responses[0].label_annotations.map(&:description)
        Rails.logger.info "Labels detected: #{labels.join(', ')}"
  
        @care_guide = PerenualApiClient.fetch_species_care_guide(translated_vegetable_name)
        @labels = labels
        @vegetable_status = determine_vegetable_status(labels)
        render 'analyze_image'
      else
        Rails.logger.error "No labels were detected."
        flash[:alert] = "画像の分析に失敗しました。ラベルが検出されませんでした。"
        redirect_to new_analyze_image_path
      end
    else
      flash[:alert] = "画像または野菜の名前が提供されていません。"
      redirect_to new_analyze_image_path
    end
  rescue StandardError => e
    Rails.logger.error "Failed to analyze image: #{e.message}"
    flash[:alert] = "画像の分析に失敗しました。エラー: #{e.message}"
    redirect_to new_analyze_image_path
  end    

  private

  def event_params
    params.require(:event).permit(:title, :start_date, :end_date, :vegetable_id, :color)
  end

  def set_vegetable
    @vegetable = Vegetable.find(params[:id])
  end

  def set_event
    @event = Event.find(params[:id])
  end

  def translate_vegetable_name(name)
    Rails.logger.info "Translating vegetable name: #{name}"
    translated_name = AzureTranslationService.translate(name, 'EN')
    Rails.logger.info "Translated vegetable name: #{translated_name}"
    translated_name
  rescue StandardError => e
    Rails.logger.error "Failed to translate vegetable name: #{e.message}"
    name # 翻訳に失敗した場合は元の名前を使用
  end

  def determine_vegetable_status(labels)
    vegetable_status = {}
  
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
  
    vegetable_status
  end
end
