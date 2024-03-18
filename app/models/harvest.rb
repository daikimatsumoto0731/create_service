# frozen_string_literal: true

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
end
