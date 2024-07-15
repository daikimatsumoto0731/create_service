# frozen_string_literal: true

class Vegetable < ApplicationRecord
  belongs_to :user
  has_many :events, dependent: :destroy

  validates :name, presence: true, length: { in: 2..10 }
  validates :sowing_date, presence: true
end
