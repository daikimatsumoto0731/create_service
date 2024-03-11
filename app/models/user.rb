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
      # LINEからの情報でユーザー属性を設定
      user.email = auth.info.email.presence || User.generate_email(auth)
      user.password = Devise.friendly_token[0, 20]
      user.username = auth.info.name.presence || "LINE User"
      user.line_user_id = auth.uid # LINEユーザーIDを保存
      # デフォルト値を設定
      user.prefecture = "未設定"
      # user.profile_image = auth.info.image が必要であれば追加
    end
  end

  # アクセストークンと有効期限を更新
  def refresh_access_token(auth)
    self.access_token = auth.credentials.token
    self.token_expires_at = Time.at(auth.credentials.expires_at) if auth.credentials.expires_at
    save!
  end
end
