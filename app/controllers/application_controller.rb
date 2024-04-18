# frozen_string_literal: true

require 'line/bot'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  add_flash_types :success, :info, :warning, :danger

  # エラーハンドリング
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActionController::RoutingError, with: :render_404
  rescue_from StandardError, with: :render_500  # ExceptionをStandardErrorに変更

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username prefecture])
  end

  def after_sign_in_path_for(resource)
    user_path(resource)
  end

  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end

  public

  def render_404(exception = nil)
    log_error(exception)
    render(file: "#{Rails.root}/public/404.html", status: :not_found, layout: false)
  end

  def render_500(exception = nil)
    log_error(exception)
    render(file: "#{Rails.root}/public/500.html", status: :internal_server_error, layout: false)
  end

  def log_error(exception)
    return unless exception
    logger.error "Error: #{exception.class} - #{exception.message}"
    logger.error exception.backtrace.join("\n")
  end
end
