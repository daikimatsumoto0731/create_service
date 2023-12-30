class UserController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # サインアップ後、ユーザーをログインさせる(オプション)
      sign_in(@user)
      # サインアップ後のリダイレクト先
      redirect_to new_user_sessions_path, notice: '登録されました'
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :prefecture, :password, :password_confirmation)
  end
end
