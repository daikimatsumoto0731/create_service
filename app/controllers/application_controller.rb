class ApplicationController < ActionController::Base
  protected

  def after_sign_in_path_for(resource)
    user_sessions_path
  end
end
