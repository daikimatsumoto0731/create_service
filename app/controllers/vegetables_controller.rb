class VegetablesController < ApplicationController
  def index
  end

  def schedule
    if params[:'selected-vegetable'].blank?
      flash[:alert] = '野菜を選択してください'
      render :index
    else
      # 選択された野菜を取得
      selected_vegetable = params[:'selected-vegetable']
      
      # スケジュール画面にリダイレクトし、選択した野菜をパラメータとして渡す
      redirect_to schedule_path(selected_vegetable: selected_vegetable)
    end
  end

  def custom_schedule
  end
end
