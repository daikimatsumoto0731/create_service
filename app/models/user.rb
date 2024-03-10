class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[line]

  # LINE認証のユーザーはusernameとprefectureのバリデーションをスキップ
  validates :username, presence: true, unless: -> { provider == 'line' }
  validates :prefecture, presence: true, unless: -> { provider == 'line' }
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

  # LINE認証で取得したuidを元に仮のメールアドレスを生成
  def self.generate_email(auth)
    "#{auth.uid}@#{auth.provider}.example.com"
  end

  def refresh_access_token(omniauth)
    self.access_token = omniauth.credentials.token
    self.token_expires_at = Time.at(omniauth.credentials.expires_at) if omniauth.credentials.expires_at
    save!
  end
end
