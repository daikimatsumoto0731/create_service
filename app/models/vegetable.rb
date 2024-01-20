class Vegetable < ApplicationRecord
  has_many :schedules, dependent: :destroy
end
