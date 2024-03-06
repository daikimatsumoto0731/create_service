class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def line
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      sign_in @user, event: :authentication # ユーザーをサインインさせます
      set_flash_message(:notice, :success, kind: "LINE") if is_navigational_format?
      redirect_to user_path(@user) # ユーザーのマイページにリダイレクトします
    else
      session['devise.line_data'] = request.env['omniauth.auth'].except('extra') # 必要に応じてセッションを設定
      redirect_to new_user_registration_url, alert: "LINEアカウントから必要な情報を取得できませんでした"
    end
  end

  def failure
    error_reason = request.env['omniauth.error.type'].to_s
    error_message = request.env['omniauth.error']&.message
    Rails.logger.info "OmniAuth Failure, reason: #{error_reason}, message: #{error_message}"
    redirect_to root_path, alert: "LINEでの認証に失敗しました。理由: #{error_message}"
  end
end
