# frozen_string_literal: true

class UserController < ApplicationController
  before_action :authenticate_user!

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # サインアップ後、ユーザーをログインさせる(オプション)
      sign_in(@user)
      # サインアップ後のリダイレクト先
      redirect_to new_user_sessions_path, flash[:notice] = '登録されました'
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :prefecture, :password, :password_confirmation)
  end
end
