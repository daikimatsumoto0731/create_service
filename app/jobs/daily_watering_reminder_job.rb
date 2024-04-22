# frozen_string_literal: true

# app/jobs/daily_watering_reminder_job.rb
class DailyWateringReminderJob
  include Sidekiq::Worker

  def perform
    User.joins(:line_notification_setting).where(line_notification_settings: { receive_notifications: true }).each do |user|
      if user.line_notification_setting.notification_time.strftime('%H:%M') == Time.current.strftime('%H:%M')
        LineBotService.send_weather_message(user.line_user_id, WeatherService.fetch_weather(user.prefecture))
      end
    end
  end
end
