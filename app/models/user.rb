# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[line]

  validates :username, presence: true, unless: -> { provider == 'line' }
  validates :prefecture, presence: true, unless: -> { provider == 'line' }
  validates :line_user_id, presence: true, if: -> { provider == 'line' }

  has_one :line_notification_setting, dependent: :destroy
  has_many :harvests, dependent: :destroy
  has_many :notifications, dependent: :destroy

  after_create :create_default_notification_setting

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email.presence || User.generate_email(auth)
      user.password = Devise.friendly_token[0, 20]
      user.username = auth.info.name.presence || 'LINE User'
      user.line_user_id = auth.uid
      user.prefecture = '未設定'
    end
  end

  private

  def create_default_notification_setting
    build_line_notification_setting(receive_notifications: true).save!
  end

  def self.generate_email(auth)
    "#{auth.uid}@example.com"
  end
end
