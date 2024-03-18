# frozen_string_literal: true

class NotificationJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    current_time = Time.current

    LineNotificationSetting.where(receive_notifications: true).find_each do |setting|
      # setting.notification_time が nil でないことを確認
      next if setting.notification_time.nil?

      # 時間が一致するか確認し、一致する場合は通知を送信
      if setting.notification_time.strftime('%H:%M') == current_time.strftime('%H:%M')
        LineNotifier.new(setting.user).send_message('水やりの時間です！')
      end
    end
  end
end
