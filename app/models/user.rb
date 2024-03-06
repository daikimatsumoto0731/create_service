class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[line]

  validates :username, presence: true
  validates :prefecture, presence: true
   validates :line_user_id, presence: true, if: -> { provider == 'line' }

  has_one :line_notification_setting, dependent: :destroy
  has_many :harvests, dependent: :destroy

  # OmniAuth認証データからユーザーを検索または作成します
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email.presence || user.email
      user.password = Devise.friendly_token[0, 20]
      user.username = auth.info.name.presence || user.username
      user.profile_image = auth.info.image
    end
  end
end
