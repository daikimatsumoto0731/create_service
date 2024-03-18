# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_vegetable, only: [:update_sowing_date]

  def index
    @selected_vegetable = params[:selected_vegetable]&.downcase
    if @selected_vegetable.present?
      @vegetable = Vegetable.find_by('lower(name) = ?', @selected_vegetable)
      if @vegetable
        # 「Button」という名前のイベントを除外
        @events = @vegetable.events.where.not(name: 'Button')
      else
        redirect_to events_path, alert: "#{@selected_vegetable} に該当する野菜は見つかりませんでした。" and return
      end
    else
      # すべてのイベントから「Button」という名前を除外
      @events = Event.where.not(name: 'Button')
    end
  
    template_name = @vegetable ? @selected_vegetable : 'default'
  
    # ここでテンプレートの存在を確認
    if lookup_context.exists?(template_name, 'events', true)
      render template: "events/#{template_name}"
    else
      # テンプレートが存在しない場合の処理
      # 例えば、デフォルトのテンプレートをレンダリングするなど
      redirect_to events_path, alert: "指定されたテンプレートが見つかりませんでした。" and return
    end
  end
  

  def advice
    @event = Event.find_by(id: params[:id])
    if @event
      vegetable_name = @event.vegetable.name.downcase
      partial_name = map_event_name_to_partial(@event.name, vegetable_name)
      render partial: "events/#{partial_name}", locals: { event: @event }, layout: false
    else
      render json: { error: 'Event not found' }, status: :not_found
    end
  end

  def update_sowing_date
    sowing_date = Date.parse(params[:sowing_date])
    @vegetable = Vegetable.find(params[:vegetable_id])

    ActiveRecord::Base.transaction do
      if @vegetable.update(sowing_date:)
        @vegetable.update_related_event_dates
        redirect_to events_path(selected_vegetable: @vegetable.name.downcase), notice: '種まき日を更新しました。'
      else
        redirect_to events_path(selected_vegetable: @vegetable.name.downcase), alert: '種まき日の更新に失敗しました。'
      end
    end
  rescue StandardError => e
    redirect_to events_path(selected_vegetable: @vegetable.name.downcase), alert: "更新中にエラーが発生しました: #{e.message}"
  end

  private

  def set_vegetable
    @vegetable = Vegetable.find_by(id: params[:vegetable_id])
    return if @vegetable

    redirect_to events_path, alert: '指定された野菜は見つかりませんでした。'
  end

  def map_event_name_to_partial(event_name, vegetable_name)
    event_key = case event_name
                when '種まき' then 'seed_sowing'
                when '発芽期間' then 'germination_period'
                when '間引き・雑草抜き・害虫駆除' then 'thinning_weeding_pest_control'
                when '収穫期間' then 'harvesting_period'
                end
    "advice_#{vegetable_name}_#{event_key}"
  end
end
