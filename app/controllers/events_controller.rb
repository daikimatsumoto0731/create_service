class EventsController < ApplicationController
  def index
    # 選択された野菜をparamsから取得
    @selected_vegetable = params[:selected_vegetable]

    @events = Event.all

    # 選択された野菜に応じて異なるビューをレンダリング
    case @selected_vegetable
    when 'tomato'
      render 'tomato'
    when 'carrot'
      render 'carrot'
    when 'basil'
      render 'basil'
    else
      redirect_to vegerables_path, alert: '選択された野菜が無効です'
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  # モーダルでアドバイスを表示するためのアクション
  def advice
    @event = Event.find(params[:id])
    # ビューを通してモーダルに表示する情報をレンダリング
    render 'advice', layout: false
  end
end
