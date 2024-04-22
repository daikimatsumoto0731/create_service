# frozen_string_literal: true

# app/jobs/daily_watering_reminder_job.rb

class DailyWateringReminderJob
  include Sidekiq::Worker

  def perform
    User.joins(:line_notification_setting).where(line_notification_settings: { receive_notifications: true }).each do |user|
      # ユーザーが設定したタイムゾーンを取得、またはデフォルトとして 'Tokyo' を使用
      user_time_zone = user.line_notification_setting.time_zone || 'Tokyo'
      
      # ユーザーのタイムゾーンに基づいた現在の時間
      current_time_in_zone = Time.current.in_time_zone(user_time_zone)

      # ユーザーの通知設定時間と現在の時間を比較
      if user.line_notification_setting.notification_time.strftime('%H:%M') == current_time_in_zone.strftime('%H:%M')
        LineBotService.send_weather_message(user.line_user_id, WeatherService.fetch_weather(user.prefecture))
      end
    end
  end
end
