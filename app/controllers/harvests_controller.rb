# frozen_string_literal: true

class HarvestsController < ApplicationController
  before_action :authenticate_user!

  def new
    @harvest = Harvest.new
    @vegetable_type = params[:vegetable_type] || 'バジル'
    set_price_per_kg(@vegetable_type)
    render_template(@vegetable_type)
  end

  def create
    @harvest = current_user.harvests.new(harvest_params) # 現在のユーザーに関連付け
    if @harvest.save
      redirect_to harvest_path(@harvest) # 単数形に修正
    else
      @vegetable_type = @harvest.vegetable_type
      set_price_per_kg(@vegetable_type)
      flash.now[:alert] = '入力に誤りがあります。'
      render_template(@vegetable_type)
    end
  end

  def show
    @harvest = Harvest.find(params[:id])
    # 節約額の計算
    @savings = @harvest.amount * @harvest.price_per_kg
  end

  def destroy_by_vegetable_type
    @user = current_user
    @user.harvests.where(vegetable_type: params[:vegetable_type]).destroy_all
    redirect_to user_path(@user), notice: 'データを削除しました'
  end

  private

  def harvest_params
    params.require(:harvest).permit(:amount, :vegetable_type, :price_per_kg)
  end

  def set_price_per_kg(vegetable_type)
    @price_per_kg = case vegetable_type
                    when 'バジル' then 250
                    when 'にんじん' then 434
                    when 'トマト' then 791
                    else 0
                    end
  end

  def render_template(vegetable_type)
    template = case vegetable_type
               when 'バジル' then 'new_basil'
               when 'にんじん' then 'new_carrot'
               when 'トマト' then 'new_tomato'
               else 'new_default'
               end
    render template
  end
end
