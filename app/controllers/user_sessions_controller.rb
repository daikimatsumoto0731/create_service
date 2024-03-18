# frozen_string_literal: true

class UserSessionsController < Devise::SessionsController
  # ユーザーのログイン処理
  def create
    self.resource = warden.authenticate!(auth_options)
    if resource
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      respond_with resource, location: after_sign_in_path_for(resource)
    else
      set_flash_message!(:alert, :invalid)
      render :new
    end
  end

  # ユーザーのログアウト処理
end
