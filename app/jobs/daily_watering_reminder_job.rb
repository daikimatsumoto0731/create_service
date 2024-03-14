# app/jobs/daily_watering_reminder_job.rb
class DailyWateringReminderJob
  include Sidekiq::Worker
    
  def perform
    User.includes(:user_setting).find_each do |user|
      # ユーザー設定が存在し、かつ通知を受け取る設定になっている場合のみ通知を送信
      if user.line_user_id.present? && user.user_setting&.should_receive_notifications?
        LineBotService.send_push_message(user.line_user_id, "水やりの時間です！")
      end
    end
  end
end
  