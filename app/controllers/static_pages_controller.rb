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
        # LINE認証情報が設定されているか確認
        if @line_notification_setting.line_auth_info_api_key.present? && @line_notification_setting.line_auth_info_user_id.present?
          # LINE通知を送信するコードを追加
          if @line_notification_setting.receive_notifications
            send_line_notification("水やりの時間です！")
          end
        end

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
    params.require(:line_notification_setting).permit(:receive_notifications, :notification_time, :line_auth_info_api_key, :line_auth_info_user_id)
  end

  def send_line_notification(message)
    # LINE通知を送信するためのコードを追加
    # ここでLINE Notify APIを使用して通知を送信します
  
    # LINE Notify APIのエンドポイント
    notify_api_endpoint = 'https://notify-api.line.me/api/notify'
  
    # LINE Notify APIのアクセストークン（APIキー）
    api_key = ENV['LINE_NOTIFY_API_KEY'] # 環境変数からアクセストークンを取得
  
    # 通知するメッセージ
    notification_message = message
  
    # 通知を送信
    response = HTTParty.post(
      notify_api_endpoint,
      body: { message: notification_message },
      headers: {
        'Authorization' => "Bearer #{api_key}"
      }
    )
  
    # レスポンスの確認とエラーハンドリング
    if response.code == 200
      # 通知が成功した場合の処理
      Rails.logger.info("LINE通知が成功しました: #{notification_message}")
    else
      # 通知が失敗した場合のエラーハンドリング
      Rails.logger.error("LINE通知が失敗しました: #{response.code}, #{response.body}")
    end
  end
end
