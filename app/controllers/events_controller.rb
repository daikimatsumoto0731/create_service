# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_vegetable, only: [:update_sowing_date, :analyze_image]

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

  def analyze_image
    require 'httparty'
  
    # 画像データにアクセス
    image_data = params[:image]
  
    # OpenAIのAPIキーを環境変数から取得
    api_key = ENV['OPENAI_API_KEY']
    api_url = 'https://api.openai.com/v1/image/generations'
  
    # デバッグログ: APIリクエスト送信前
    Rails.logger.debug("Sending request to OpenAI API with image data: #{image_data}")
  
    # APIリクエストを送信
    response = HTTParty.post(
      api_url,
      headers: {
        "Authorization" => "Bearer #{api_key}",
        "Content-Type" => "application/json"
      },
      body: {
        authenticity_token: form_authenticity_token, # CSRFトークンを含める
        prompt: "Analyze this image and provide advice for growing better #{@selected_vegetable}",
        image: Base64.strict_encode64(image_data.read),
        n: 1
      }.to_json
    )
  
    # デバッグログ: APIレスポンス受信後
    Rails.logger.debug("Received response from OpenAI API: #{response}")
  
    # APIレスポンスの処理
    if response.success?
      advice = response.parsed_response['choices'].first['data']['text']
    else
      advice = "Analysis failed: #{response.body}"
    end
  
    # 画像分析の結果をビューに表示
    render 'analyze_image', locals: { advice: advice }
  end
  
  private

  private

  def set_vegetable
    @vegetable = Vegetable.find_by(id: params[:vegetable_id])
    redirect_to(events_path, alert: t('errors.vegetables.not_found')) unless @vegetable
  end

  def handle_vegetable_selection
    return unless @selected_vegetable.present?

    @vegetable = Vegetable.find_by('lower(name) = ?', @selected_vegetable)
    unless @vegetable
      flash[:alert] = "#{@selected_vegetable} に該当する野菜は見つかりませんでした。"
      redirect_to events_path
      return
    end

    @events = @vegetable.events.where.not(name: 'Button').order(sort_events_query)
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
        flash[:notice] = '種まき日を更新しました。' # メッセージをフラッシュに設定
        redirect_to events_path(selected_vegetable: @vegetable.name.downcase)
      else
        flash[:alert] = '種まき日の更新に失敗しました。' # エラーメッセージをフラッシュに設定
        redirect_to events_path(selected_vegetable: @vegetable.name.downcase)
      end
    end
  rescue StandardError => e
    flash[:alert] = "更新中にエラーが発生しました: #{e.message}" # エラーメッセージをフラッシュに設定
    redirect_to events_path(selected_vegetable: @vegetable.name.downcase)
  end
end
