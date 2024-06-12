# frozen_string_literal: true

class HarvestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_harvest, only: [:show]

  def show
    # 節約額を計算
    @savings = (@harvest.amount * @harvest.price_per_kg / 1000.0).round(2)
    @price_per_kg = @harvest.price_per_kg # 直接キログラム単位の価格を使用
  end

  def new
    @harvest = Harvest.new
    @vegetable_type = params[:vegetable_type] || 'バジル'
    price_per_kg(@vegetable_type) # メソッド名を変更
    render_template(@vegetable_type)
  end

  def create
    @harvest = current_user.harvests.new(harvest_params)

    # 市場価格を設定（キログラム単位で）
    @vegetable_type = params[:harvest][:vegetable_type]
    price_per_kg(@vegetable_type) # メソッド名を変更
    @harvest.price_per_kg = @price_per_kg # グラム単位の変換を除去

    if @harvest.save
      redirect_to harvest_path(@harvest), notice: t('.success')
    else
      flash.now[:alert] = t('.error')
      render_template(@vegetable_type)
    end
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
