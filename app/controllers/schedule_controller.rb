class ScheduleController < ApplicationController
  def custom_schedule
    @selected_vegetable = params[:selected_vegetable].downcase

    vegetable = Vegetable.find_by(name: @selected_vegetable)
    @schedules = vegetable ? vegetable.schedules : Schedule.none

    @selected_vegetable_name = case @selected_vegetable
                                when "tomato" then "トマト"
                                when "carrot" then "ニンジン"
                                when "basil" then "バジル"
                                end
    respond_to do |format|
      format.html do
        if vegetable.present?  # 野菜が存在する場合のみ該当のビューをレンダリング
          render template: "schedule/#{@selected_vegetable}"
        else
          # 野菜が存在しない場合の処理
          redirect_to vegetables_path, alert: "指定された野菜は存在しません"
        end
      end
      format.json { render json: @schedules }
    end
  end

  def planting_advice; end

  def thinning_advise; end
end
