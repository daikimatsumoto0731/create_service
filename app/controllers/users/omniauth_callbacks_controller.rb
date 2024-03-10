class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def line
    basic_action
  end

  private

  def basic_action
    @omniauth = request.env["omniauth.auth"]
    if @omniauth.present?
      @profile = User.find_or_initialize_by(provider: @omniauth["provider"], uid: @omniauth["uid"])
  
      if @profile.new_record?
        email = @omniauth["info"]["email"].presence || fake_email(@omniauth["uid"], @omniauth["provider"])
        @profile.assign_attributes(
          email: email,
          name: @omniauth["info"]["name"] || "LINE User",
          password: Devise.friendly_token[0, 20],
          # その他必要な属性の設定
        )
  
        unless @profile.valid?
          logger.debug @profile.errors.full_messages
          # 他のエラー処理（エラーメッセージをユーザーに表示する等）
        end
  
        @profile.save!
      end
  
      # アクセストークンの更新とサインイン
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