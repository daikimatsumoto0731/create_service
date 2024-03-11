class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]

  def show
    @user = User.find(params[:id])
    @aggregated_harvests = Harvest.aggregate_by_vegetable_type(@user)
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'プロフィールが更新されました'
    else
      render :edit
    end
  end

  private
  
  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:username, :email, :prefecture)
  end
end
