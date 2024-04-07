# frozen_string_literal: true

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
