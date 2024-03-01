class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def line
    # LINEからの認証情報をログに出力
    Rails.logger.info "OmniAuth auth: #{request.env['omniauth.auth'].inspect}"

    @user = User.from_omniauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "LINE") if is_navigational_format?
    else
      session['devise.line_data'] = request.env['omniauth.auth'].except('extra')
      redirect_to new_user_registration_url, alert: "LINEアカウントから必要な情報を取得できませんでした"
    end
  end
  
  def failure
    redirect_to root_path, alert: "LINEでの認証に失敗しました"
  end
end
