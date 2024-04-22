# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update]

  def show
    @aggregated_harvests = Harvest.aggregate_by_vegetable_type(@user)
    # ユーザーに紐づく通知データをビューに渡すためのインスタンス変数を追加
    @notifications = @user.notifications.order(sent_at: :desc).limit(5)

    max_info = Harvest.calculate_max_savings_month(current_user)
    @max_savings_month = max_info[:max_savings_info][:month]
    @max_savings_amount = max_info[:max_savings_info][:total_savings]
    @most_harvested_vegetable = max_info[:max_harvest_info][:vegetable_type]
    @most_harvested_amount = max_info[:max_harvest_info][:total_amount]

    @vegetable_types_json = @aggregated_harvests.map(&:vegetable_type).to_json

    # ユーザーの選択した都道府県に基づく天気情報を取得
    if @user.prefecture.present?
      weather_response = WeatherService.fetch_weather(@user.prefecture)
      @weather_info = weather_response['weather'] ? weather_response['weather'][0]['description'] : '情報が取得できませんでした'
      @temperature_info = weather_response['main'] ? "#{weather_response['main']['temp']} ℃" : '情報が取得できませんでした'
    else
      @weather_info = '都道府県が設定されていません'
      @temperature_info = ''
    end
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
