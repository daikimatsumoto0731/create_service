class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def line
    basic_action
  end

  private

  def basic_action
    @omniauth = request.env["omniauth.auth"]
    if @omniauth.present?
      @profile = User.find_or_initialize_by(provider: @omniauth["provider"], uid: @omniauth["uid"])
      # ユーザー情報がデータベースに存在しない場合、新規登録を行う
      if @profile.new_record?
        email = @omniauth["info"]["email"].presence || fake_email(@omniauth["uid"], @omniauth["provider"])
        @profile.assign_attributes(email:, name: @omniauth["info"]["name"],
                                   password: Devise.friendly_token[0, 20])
        @profile.save!
      end
      # アクセストークンの更新
      @profile.refresh_access_token(@omniauth)
      sign_in(:user, @profile)
      redirect_to user_path(current_user), notice: "ログインしました"
    else
      redirect_to new_user_session_path, alert: "LINE認証に失敗しました"
    end
  end

  def fake_email(uid, provider)
    "#{uid}-#{provider}-#{SecureRandom.hex(5)}@example.com"
  end
end