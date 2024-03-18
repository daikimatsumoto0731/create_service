# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update]

  def show
    @aggregated_harvests = Harvest.aggregate_by_vegetable_type(@user)
    # ユーザーに紐づく通知データをビューに渡すためのインスタンス変数を追加
    @notifications = @user.notifications.order(sent_at: :desc).limit(5)
  end

  def edit; end

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
