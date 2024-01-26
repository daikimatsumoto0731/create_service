class LineNotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  before_action :set_line_notification_setting
    
  def edit
    # LINE通知設定画面を表示
  end
    
  def update
    if @line_notification_setting.update(line_notification_setting_params)
      send_line_notification if should_send_line_notification?
      redirect_to line_notification_settings_path, notice: '設定が更新されました。'
    else
      flash.now[:alert] = '設定の更新に失敗しました。'
      render :edit
    end
  end
    
  # LINE Notifyからの通知を受け取るアクションを追加
  def notify_callback
    # LINE Notifyからの通知を受け取り、処理するコードをここに記述
    # 通知メッセージを解析し、必要な処理を行う
      
    # 通知メッセージの取得
    notification_message = params[:message]
      
    if notification_message.present?
      # 通知メッセージが存在する場合、ユーザーにLINE通知を送信
      send_line_notification(notification_message)
    end
      
    # LINE Notifyへのレスポンスを返す（必要に応じて）
    render plain: 'OK', status: :ok
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
    
  def should_send_line_notification?
    @line_notification_setting.receive_notifications? &&
    @line_notification_setting.line_auth_info_api_key.present? &&
    @line_notification_setting.line_auth_info_user_id.present?
  end
    
  def send_line_notification(message)
    # LINE通知を送信するコードはそのまま使用
    notifier = LineNotifier.new(@user.line_auth_info_api_key)
    notifier.send_message(message)
  end
end