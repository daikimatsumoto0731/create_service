class LineNotificationSetting < ApplicationRecord
  belongs_to :user

  validates :receive_notifications, inclusion: { in: [true, false] }
  validates :notification_time, presence: true, if: -> { receive_notifications }

  validates :line_auth_info_api_key, presence: true
  validates :line_auth_info_user_id, presence: true
end
