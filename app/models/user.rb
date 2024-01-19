class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # バリデーションの追加
  validates :username, presence: true
  validates :prefecture, presence: true

  # LINE通知設定モデルへの関連付け
  has_one :line_notification_setting, dependent: :destroy
end
