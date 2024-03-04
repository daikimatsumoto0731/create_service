class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def line
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "LINE") if is_navigational_format?
    else
      session['devise.line_data'] = request.env['omniauth.auth'].except(:extra) # Removing extra as it can overflow some session stores
      redirect_to new_user_registration_url, alert: "LINEアカウントから必要な情報を取得できませんでした。"
    end
  end

  def failure
    # ユーザーを自動ログインが無効な認可URLへリダイレクト
    message = "LINEでの認証に失敗しました。再度ログインを試みてください。"
    client_id = ENV['LINE_CHANNEL_ID']
    redirect_uri = CGI.escape("https://vegetable-services-3fae4f23ca19.herokuapp.com/users/auth/line/callback")
    state = SecureRandom.hex(15)
    disable_auto_login_url = "https://access.line.me/oauth2/v2.1/authorize?disable_auto_login=true&response_type=code&client_id=#{client_id}&redirect_uri=#{redirect_uri}&state=#{state}&scope=profile%20openid&nonce=#{SecureRandom.hex(10)}"
    
    redirect_to disable_auto_login_url, alert: message, allow_other_host: true
  end
end
