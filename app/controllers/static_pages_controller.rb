class StaticPagesController < ApplicationController
  before_action :authenticate_user!, only: [:line_notification_settings]
  before_action :set_user, only: [:line_notification_settings]

  def top; end

  def terms; end
  
  def privacy_policy; end

  def line_notification_settings; end

  private

  def set_user
    @user = current_user
  end
end
