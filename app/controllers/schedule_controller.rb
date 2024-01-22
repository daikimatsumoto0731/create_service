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

    if vegetable.present?  # 野菜が存在する場合のみ該当のビューをレンダリング
      render template: "schedule/#{@selected_vegetable}"
    end
  end
end
