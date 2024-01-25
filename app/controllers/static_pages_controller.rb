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
        if @line_notification_setting.line_auth_info_api_key.present? && @line_notification_setting.line_auth_info_user_id.present?
          if @line_notification_setting.receive_notifications
            # LINEのIDを取得し、ユーザーのレコードを更新
            line_user_id = params[:line_notification_setting][:line_auth_info_user_id]
            @user.update(line_user_id: line_user_id)
            
            # 通知メッセージを定義
            notification_message = "水やりの時間です！"
            Rails.logger.info("通知メッセージ: #{notification_message}")
            
            # LineNotifierを使用してLINE通知を送信
            notifier = LineNotifier.new(@user)
            notifier.send_message(notification_message)
          end
        end
        redirect_to line_notification_settings_path, notice: '設定が更新されました。'
      else
        flash.now[:alert] = '設定の更新に失敗しました。'
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
    params.require(:line_notification_setting).permit(:receive_notifications, :notification_time, :line_auth_info_api_key, :line_auth_info_user_id)
  end
end
