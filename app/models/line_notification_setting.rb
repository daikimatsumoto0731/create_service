class LineNotificationSetting < ApplicationRecord
  belongs_to :user

  validates :receive_notifications, inclusion: { in: [true, false] }
  validates :frequency, inclusion: { in: %w[daily weekly monthly] }
end
