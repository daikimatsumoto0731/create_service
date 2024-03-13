# app/jobs/daily_watering_reminder_job.rb
class DailyWateringReminderJob
  include Sidekiq::Worker
    
  def perform
    User.find_each do |user|
      if user.line_user_id.present?
        LineBotService.send_push_message(user.line_user_id, "水やりの時間です！")
      end
    end
  end
end
  