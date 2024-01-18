class Users::PasswordsController < Devise::PasswordsController
  # PUT /resource/password
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?
  
    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
        
      set_flash_message!(:notice, :password_changed) # カスタムのフラッシュメッセージ
      # パスワード再設定後にログイン画面にリダイレクト
      redirect_to new_user_session_path and return
    else
      set_minimum_password_length
      respond_with resource
    end
  end
end
  