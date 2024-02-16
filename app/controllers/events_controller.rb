class EventsController < ApplicationController
  def index
    # 選択された野菜をparamsから取得
    @selected_vegetable = params[:selected_vegetable]

    # 選択された野菜に基づいてイベントをフィルタリング
    if @selected_vegetable.present?
      @events = Event.joins(:vegetable).where(vegetables: { name: @selected_vegetable })
    else
      @events = Event.all
    end

    # 選択された野菜に応じて異なるビューをレンダリング
    render @selected_vegetable || 'default'
  end

  def advice
    @event = Event.find_by(id: params[:id])
    if @event
      partial_name = map_event_name_to_partial(@event.name)
      render partial: "events/#{partial_name}", locals: { event: @event }, layout: false
    else
      render json: { error: "Event not found" }, status: :not_found
    end
  end

  private

  def map_event_name_to_partial(name)
    case name
    when "種まき"
      "advice_seed_sowing"
    when "発芽期間"
      "advice_germination_period"
    when "間引き・雑草抜き・害虫駆除"
      "advice_thinning_weeding_pest_control"
    when "収穫期間"
      "advice_harvesting_period"
    else
      "advice_default" # デフォルトのパーシャルを指定
    end
  end
end
