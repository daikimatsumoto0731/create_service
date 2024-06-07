# frozen_string_literal: true

class Vegetable < ApplicationRecord
  belongs_to :user
  has_many :events, dependent: :destroy

  validates :name, presence: true
  validates :sowing_date, presence: true
end
