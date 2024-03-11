class StaticPagesController < ApplicationController
  before_action :authenticate_user!

  def top; end

  def terms; end
  
  def privacy_policy; end
end
