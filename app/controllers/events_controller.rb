class EventsController < ApplicationController
  before_action :set_vegetable, only: [:update_sowing_date]
  def index
    @selected_vegetable = params[:selected_vegetable]
    if @selected_vegetable.present?
      @vegetable = Vegetable.find_by(name: @selected_vegetable.capitalize)
      @events = Event.joins(:vegetable).where(vegetables: { name: @selected_vegetable })
    else
      @events = Event.all
    end
    render @selected_vegetable || 'default'
  end

  def advice
    @event = Event.find_by(id: params[:id])
    if @event
      vegetable_name = @event.vegetable.name.downcase
      partial_name = map_event_name_to_partial(@event.name, vegetable_name)
      render partial: "events/#{partial_name}", locals: { event: @event }, layout: false
    else
      render json: { error: "Event not found" }, status: :not_found
    end
  end

  def update_sowing_date
    sowing_date = params[:sowing_date]
    # 文字列の日付をDateオブジェクトに変換する処理が必要な場合はここで実施
    if @vegetable.update(sowing_date: sowing_date)
      @vegetable.update_related_event_dates
      redirect_to events_path(selected_vegetable: @vegetable.name), notice: '種まき日を更新しました。'
    else
      redirect_to events_path(selected_vegetable: @vegetable.name), alert: '種まき日の更新に失敗しました。'
    end
  end  

  private

  def set_vegetable
    @vegetable = Vegetable.find(params[:vegetable_id])
  end

  def map_event_name_to_partial(event_name, vegetable_name)
    event_key = case event_name
                when "種まき" then "seed_sowing"
                when "発芽期間" then "germination_period"
                when "間引き・雑草抜き・害虫駆除" then "thinning_weeding_pest_control"
                when "収穫期間" then "harvesting_period"
                else "default"
                end

    "advice_#{vegetable_name}_#{event_key}"
  end
end
