# frozen_string_literal: true

class DailyWateringReminderJob
  include Sidekiq::Worker

  def perform
    # 通知を受け取る設定がtrueになっているユーザーを取得
    users = User.joins(:line_notification_setting).where(line_notification_settings: { receive_notifications: true })

    # 各ユーザーに対して天気情報を送信
    users.each do |user|
      weather_data = WeatherService.fetch_weather(user.prefecture)
      LineBotService.send_weather_message(user.line_user_id, weather_data)
    end
  end
end
