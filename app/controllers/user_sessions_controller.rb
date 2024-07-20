# frozen_string_literal: true

class UserSessionsController < Devise::SessionsController
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

  protected

  def after_sign_out_path_for(_resource_or_scope)
    root_path
  end
end
