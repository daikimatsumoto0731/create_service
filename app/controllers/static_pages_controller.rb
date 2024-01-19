class StaticPagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  before_action :set_line_notification_setting, only: [:line_notification_settings]

  def top; end

  def terms; end
  
  def privacy_policy; end

  def line_notification_settings
    if request.patch?
      if @line_notification_setting.update(line_notification_setting_params)
        redirect_to line_notification_settings_path, notice: '設定ができました'
      else
        flash.now[:alert] = '設定ができませんでした'
        render :line_notification_settings
      end
    end
  end

  private

  def set_user
    @user = current_user
  end

  def set_line_notification_setting
    @line_notification_setting = @user.line_notification_setting || @user.build_line_notification_setting
  end

  def line_notification_setting_params
    params.require(:line_notification_setting).permit(:receive_notifications, :frequency)
  end
end
