# frozen_string_literal: true

class HarvestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_harvest, only: [:show]

  def new
    @harvest = Harvest.new
    @vegetable_type = params[:vegetable_type] || 'バジル'
    price_per_kg(@vegetable_type)
    render_template(@vegetable_type)
  end

  def create
    @harvest = current_user.harvests.new(harvest_params)
    
    # キログラムからグラムに変換
    @harvest.amount *= 1000 if @harvest.amount.present?
  
    if @harvest.save
      redirect_to harvest_path(@harvest), notice: t('.success')
      Rails.logger.info("Redirected to: #{harvest_path(@harvest)}") # リダイレクト先のURLをログに出力
    else
      @vegetable_type = params[:harvest][:vegetable_type]
      price_per_kg(@vegetable_type)
      flash.now[:alert] = t('.error')
      render_template(@vegetable_type)
    end
  end    

  def show
    # 節約額の計算
    if @harvest.price_per_kg.present?
      # グラムからキログラムに変換
      @savings = (@harvest.amount / 1000.0) * @harvest.price_per_kg
    else
      @savings = 0
    end
  end

  def destroy_by_vegetable_type
    @user = current_user
    @harvests = @user.harvests.where(vegetable_type: params[:vegetable_type])
    @harvests.destroy_all
    redirect_to user_path(@user), notice: t('.success')
  end

  private

  def set_harvest
    @harvest = Harvest.find_by(id: params[:id])
    redirect_to root_path, alert: t('.not_found') unless @harvest
  end

  def harvest_params
    params.require(:harvest).permit(:amount, :vegetable_type, :price_per_kg)
  end

  def price_per_kg(vegetable_type)
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
