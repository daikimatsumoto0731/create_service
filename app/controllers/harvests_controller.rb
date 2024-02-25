class HarvestsController < ApplicationController
  def new
    @harvest = Harvest.new
    @vegetable_type = params[:vegetable_type] || "バジル"
    
    # 各野菜の平均価格を設定
    case @vegetable_type
    when "バジル"
      @price_per_kg = 250 # 100gあたり約250円
      render "new_basil"
    when "にんじん"
      @price_per_kg = 434 # 1kgあたり約434円
      render "new_carrot"
    when "トマト"
      @price_per_kg = 791 # 1kgあたり約791円
      render "new_tomato"
    else
      @price_per_kg = 0 # 不明な野菜タイプの場合
      render "new_default"
    end

    
  end  

  def create
    @harvest = Harvest.new(harvest_params)
    if @harvest.save
      # 節約額の計算
      @savings = @harvest.amount * @harvest.price_per_kg
      # 成功時の処理
      render :show
    else
      # 失敗時の処理
      flash.now[:alert] = "入力に誤りがあります"
      render :new
    end
  end

  private

  def harvest_params
    params.require(:harvest).permit(:amount, :vegetable_type, :price_per_kg)
  end
end
