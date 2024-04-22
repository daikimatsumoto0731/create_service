# frozen_string_literal: true

class DailyWateringReminderJob
  include Sidekiq::Worker

  def perform
    Rails.logger.info 'DailyWateringReminderJob started'
    User.joins(:user_setting).find_each do |user|
      if user.line_user_id.present? && user.user_setting&.should_receive_notifications?
        # ユーザーの都道府県から天気情報を取得
        weather_data = WeatherService.fetch_weather(user.prefecture)
        if weather_data['weather']  # 天気情報が正常に取得できた場合
          Rails.logger.info "Sending weather-based push message to user: #{user.id}"
          begin
            LineBotService.send_weather_message(user.line_user_id, weather_data)
          rescue StandardError => e
            Rails.logger.error "Error sending weather-based push message: #{e.message}"
          end
        else
          Rails.logger.error "Failed to fetch weather data for user: #{user.id}"
        end
      end
    end
    Rails.logger.info 'DailyWateringReminderJob finished'
  end
end
