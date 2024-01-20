class VegetablesController < ApplicationController
  def index
  end

  def schedule
    selected_vegetable = params[:selected_vegetable]

    if selected_vegetable.blank?
      redirect_to vegetables_path  # 選択されていない場合は野菜選択画面にリダイレクト
    else
      # 選択された野菜をスケジュール画面に渡す
      redirect_to custom_schedule_path(selected_vegetable: selected_vegetable)
    end
  end
end
