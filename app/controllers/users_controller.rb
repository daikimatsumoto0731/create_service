class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @aggregated_harvests = Harvest.aggregate_by_vegetable_type(@user)
  end
end
