class Vegetable < ApplicationRecord
  has_many :events, dependent: :destroy
end
