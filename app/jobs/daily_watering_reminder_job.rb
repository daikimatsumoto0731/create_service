class DailyWateringReminderJob
  include Sidekiq::Worker
      
  def perform
    Rails.logger.info "DailyWateringReminderJob started"
    User.includes(:user_setting).find_each do |user|
      if user.line_user_id.present? && user.user_setting&.should_receive_notifications?
        Rails.logger.info "Sending push message to user: #{user.id}"
        begin
          response = LineBotService.send_push_message(user.line_user_id, "水やりの時間です！")
          Rails.logger.info "Push message sent successfully: #{response}"
        rescue => e
          Rails.logger.error "Error sending push message: #{e.message}"
        end
      end
    end
    Rails.logger.info "DailyWateringReminderJob finished"
  end
  end
  