class LineNotificationSetting < ApplicationRecord
  belongs_to :user

  validates :receive_notifications, inclusion: { in: [true, false] }
  validates :notification_time, presence: true, if: -> { receive_notifications }
end
