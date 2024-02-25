class Harvest < ApplicationRecord
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :vegetable_type, presence: true
  validates :price_per_kg, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
