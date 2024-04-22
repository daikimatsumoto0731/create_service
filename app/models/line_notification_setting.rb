# frozen_string_literal: true

class LineNotificationSetting < ApplicationRecord
  belongs_to :user

  validates :receive_notifications, inclusion: { in: [true, false] }
  validates :notification_time, presence: true, if: -> { receive_notifications }
  validates :time_zone, presence: true, if: -> { receive_notifications && notification_time.present? }
end
