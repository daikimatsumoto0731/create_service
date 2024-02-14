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
    case @selected_vegetable
    when 'tomato'
      render 'tomato'
    when 'carrot'
      render 'carrot'
    when 'basil'
      render 'basil'
    else
      redirect_to vegetables_path, alert: '選択された野菜が無効です'
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  # モーダルでアドバイスを表示するためのアクション
  def advice
    @event = Event.find_by(id: params[:id])
    if @event
      render partial: "events/advice", locals: { event: @event }, layout: false
    else
      render json: { error: "Event not found" }, status: :not_found
    end
  end  
end
