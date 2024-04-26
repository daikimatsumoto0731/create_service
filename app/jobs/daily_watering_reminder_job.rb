# frozen_string_literal: true

class DailyWateringReminderJob
  include Sidekiq::Worker

  def perform
    User.joins(:line_notification_setting).where(line_notification_settings: { receive_notifications: true }).each do |user|
      weather_data = WeatherService.fetch_weather(user.prefecture)
      LineBotService.send_weather_message(user.line_user_id, weather_data)
    end
  end
end
