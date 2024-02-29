class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[line]

  validates :username, presence: true
  validates :prefecture, presence: true

  has_one :line_notification_setting, dependent: :destroy
  has_many :harvests, dependent: :destroy

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      # LINEから受け取る他のデータもここで設定する
      # 例: user.name = auth.info.name
    end
  end
  
  def social_profile(provider)
    # LINE認証時には、このメソッドのロジックが適用される場合があります。
    # 必要に応じて、ここでの処理を実装してください。
  end

  def set_values(omniauth)
    # LINE認証からのデータを基に、必要なユーザー情報を設定するロジックをここに追加します。
    # 上記のfrom_omniauthメソッドで大部分の処理が行われるため、このメソッドの使用が必要な場合は特に注意してください。
  end
end
