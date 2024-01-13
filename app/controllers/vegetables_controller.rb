class VegetablesController < ApplicationController
  def index
    # 他の必要な処理をここに追加
  end

  def schedule
    if params[:selected_vegetable].blank?
      flash[:alert] = '選択してください'
      redirect_to vegetables_path
    else
      redirect_to schedule_path
    end
  end

  def custom_schedule
    redirect_to vegetables_path
  end
end
