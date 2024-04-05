class Harvest < ApplicationRecord
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :vegetable_type, presence: true
  validates :price_per_kg, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Userモデルへの関連付け
  belongs_to :user

  # ユーザーに紐づく収穫記録を野菜の種類ごとに集計
  def self.aggregate_by_vegetable_type(user)
    where(user:)
      .group(:vegetable_type)
      .select('vegetable_type, SUM(amount) as total_amount, SUM(amount * price_per_kg) as total_savings')
  end

  def self.calculate_max_savings_month(user)
    grouped_savings = where(user: user)
                      .group("TO_CHAR(created_at, 'YYYY-MM')")
                      .select("TO_CHAR(created_at, 'YYYY-MM') as month, SUM(amount * price_per_kg) as total_savings")
                      .order('total_savings DESC')
                      .first
  
    max_savings_info = { month: grouped_savings&.month, total_savings: grouped_savings&.total_savings }
  
    grouped_harvests = where(user: user)
                       .group(:vegetable_type)
                       .select('vegetable_type, SUM(amount) as total_amount')
                       .order('total_amount DESC')
                       .first
  
    max_harvest_info = { vegetable_type: grouped_harvests&.vegetable_type, total_amount: grouped_harvests&.total_amount }
  
    { max_savings_info: max_savings_info, max_harvest_info: max_harvest_info }
  end  
end
