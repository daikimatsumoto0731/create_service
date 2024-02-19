class EventsController < ApplicationController
  def index
    @selected_vegetable = params[:selected_vegetable]
    if @selected_vegetable.present?
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

  private

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
