# frozen_string_literal: true

# app/jobs/daily_watering_reminder_job.rb

class DailyWateringReminderJob
  include Sidekiq::Worker

  def perform
    # 通知を受け取るユーザーをすべて取得
    User.joins(:line_notification_setting).where(line_notification_settings: { receive_notifications: true }).each do |user|
      # 天気データを取得し、メッセージを送信
      weather_data = WeatherService.fetch_weather(user.prefecture)
      LineBotService.send_weather_message(user.line_user_id, weather_data)
    end
  end
end
