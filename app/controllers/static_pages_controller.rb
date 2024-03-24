class StaticPagesController < ApplicationController
  before_action :authenticate_user!, except: [:top, :terms, :privacy_policy]

  def top; end

  def terms; end

  def privacy_policy; end
end
