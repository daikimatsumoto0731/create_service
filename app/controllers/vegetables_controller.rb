class VegetablesController < ApplicationController
  def index; end

  def schedule
    selected_vegetable = params[:selected_vegetable]
    selected_date = params[:sowing_date] # 修正: 選択された日付を取得

    if selected_vegetable.blank?
      redirect_to vegetables_path # 選択されていない場合は野菜選択画面にリダイレクト
    else
      # 選択された野菜をスケジュール画面に渡す
      # 修正: 選択された日付をセッションに保存
      session[:selected_date] = selected_date
      redirect_to events_path(selected_vegetable:)
    end
  end
end
