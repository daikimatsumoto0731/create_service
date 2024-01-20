class ScheduleController < ApplicationController
  def custom_schedule
    @selected_vegetable = params[:selected_vegetable]
    
    # Railsのログにパラメータとテンプレートの存在を出力
    Rails.logger.debug "Selected vegetable: #{@selected_vegetable}"
    template_exists = lookup_context.template_exists?(@selected_vegetable, "schedule", false)
    Rails.logger.debug "Template exists for #{@selected_vegetable}: #{template_exists}"

    if template_exists
      render template: "schedule/#{@selected_vegetable}"
    else
      render 'schedule/default_schedule'
    end
  end
end
