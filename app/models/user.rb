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
<<<<<<< HEAD
  
  def social_profile(provider)
    social_profile.select { |sp| sp.provider == provider.to_s }.first
  end

  def set_values(omniauth)
    return if provider.to_s != omniauth["provider"].to_s || uid != omniauth["uid"]
    credentials = omniauth["credentials"]
    info = omniauth["info"]

    access_token = credentials["refresh_token"]
    access_secret = credentials["secret"]
    credentials = credentials.to_json
    name = info["name"]
  end

  def set_value_by_raw_info(raw_info)
    self.raw_info = raw_info.to_json
    self.save!
  end
=======
>>>>>>> create_19
end
