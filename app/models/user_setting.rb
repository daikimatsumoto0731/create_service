class UserSetting < ApplicationRecord
  belongs_to :user

  # receive_notificationsがtrueまたはfalseであることを保証するバリデーション
  validates :receive_notifications, inclusion: { in: [true, false] }
  # watering_timeが存在することを保証するバリデーションを追加する場合
  validates :watering_time, presence: true

  # 通知を受け取るべきかどうかを判断するメソッド
  def should_receive_notifications?
    receive_notifications
  end
end
