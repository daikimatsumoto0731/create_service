# frozen_string_literal: true

# app/controllers/line_notifications_controller.rb
class LineNotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  before_action :set_line_notification_setting

  def edit
    # LINE通知設定画面を表示
  end

  def update
    if @line_notification_setting.update(line_notification_setting_params)
      redirect_to line_notification_settings_path, notice: '設定が更新されました。'
    else
      flash.now[:alert] = '設定の更新に失敗しました。'
      render :edit
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
    params.require(:line_notification_setting).permit(:receive_notifications, :notification_time)
  end
end
