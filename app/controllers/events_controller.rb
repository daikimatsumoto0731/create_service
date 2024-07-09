# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_vegetable, only: %i[show]
  before_action :set_event, only: [:destroy]

  include AnalyzeImageModule
  include VegetableStatusModule

  def index
    events = Event.where(vegetable_id: params[:vegetable_id])
    render json: events.to_json(only: %i[id title start_date end_date color])
  end

  def show
    @selected_vegetable = params[:selected_vegetable]
    @sowing_date = params[:sowing_date]
    respond_to do |format|
      format.html
      format.json do
        render json: Event.where(vegetable_id: @vegetable.id).to_json(only: %i[id title start_date end_date color])
      end
    end
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
    @event.destroy
    head :no_content
  end

  def new_analyze_image
    # ページの初期表示用
  end

  def analyze_image
    image = params[:image]
    vegetable_name = params[:vegetable_name]

    if image && vegetable_name.present?
      handle_image_analysis(image, vegetable_name)
    else
      handle_missing_image_or_name
    end
  rescue StandardError => e
    handle_analysis_error(e)
  end

  private

  def handle_image_analysis(image, vegetable_name)
    labels, translated_vegetable_name = analyze_image_labels(image, vegetable_name)
    if labels
      process_analysis_results(labels, translated_vegetable_name)
    else
      redirect_to_failure
    end
  end

  def process_analysis_results(labels, translated_vegetable_name)
    @care_guide = PerenualApiClient.fetch_species_care_guide(translated_vegetable_name)
    @labels = labels
    @vegetable_status = determine_vegetable_status(labels)
    render partial: 'analyze_image_result',
           locals: {
             care_guide: @care_guide,
             vegetable_status: @vegetable_status,
             vegetable_name: translated_vegetable_name
           }
  end

  def event_params
    params.require(:event).permit(:title, :start_date, :end_date, :vegetable_id, :color)
  end

  def set_vegetable
    @vegetable = Vegetable.find(params[:id])
  end

  def set_event
    @event = Event.find(params[:id])
  end

  def handle_missing_image_or_name
    flash[:alert] = I18n.t('flash.alerts.image_or_name_missing')
    redirect_to new_analyze_image_path
  end

  def handle_analysis_error(exception)
    Rails.logger.error "Failed to analyze image: #{exception.message}"
    flash[:alert] = I18n.t('flash.alerts.image_analysis_error', message: exception.message)
    redirect_to new_analyze_image_path
  end

  def redirect_to_failure
    flash[:alert] = I18n.t('flash.alerts.image_analysis_failed')
    redirect_to new_analyze_image_path
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
end
