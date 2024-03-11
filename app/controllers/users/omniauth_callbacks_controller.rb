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
        # ユーザー情報がデータベースに存在しない場合、新規登録を行う
        email = @omniauth["info"]["email"].presence || fake_email(@omniauth["uid"], @omniauth["provider"])
        # assign_attributes の引数を修正
        @profile.assign_attributes(email: email, name: @omniauth["info"]["name"] || "LINE User",
                                   password: Devise.friendly_token[0, 20],
                                   line_user_id: @omniauth["uid"]) # LINEユーザーIDを保存
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
