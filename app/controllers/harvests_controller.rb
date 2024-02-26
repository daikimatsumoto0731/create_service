class HarvestsController < ApplicationController
  before_action :authenticate_user!

  def new
    @harvest = current_user.harvests.build
    set_vegetable_info
  end

  def create
    @harvest = current_user.harvests.build(harvest_params)
    if @harvest.save
      redirect_to user_path(current_user), notice: '収穫情報を保存しました。'
    else
      set_vegetable_info
      render :new
    end
  end

  private

  def set_vegetable_info
    @vegetable_type = params[:vegetable_type] || "バジル"
    
    case @vegetable_type
    when "バジル"
      @default_price_per_kg = 2500 # 100gあたり約250円、1kgあたりに変換
    when "にんじん"
      @default_price_per_kg = 434 # 1kgあたり約434円
    when "トマト"
      @default_price_per_kg = 791 # 1kgあたり約791円
    else
      @default_price_per_kg = 0 # 不明な野菜タイプの場合
    end
  end

  def harvest_params
    params.require(:harvest).permit(:amount, :vegetable_type, :price_per_kg)
  end
end
