# frozen_string_literal: true

class Harvest < ApplicationRecord
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :vegetable_type, presence: true
  validates :price_per_kg, presence: true, numericality: { greater_than_or_equal_to: 0 }

  belongs_to :user

  def self.aggregate_by_vegetable_type(user)
    where(user: user)
      .group(:vegetable_type)
      .select('vegetable_type, SUM(amount) as total_amount, SUM(amount * price_per_kg) as total_savings')
  end

  def self.calculate_max_savings_month(user)
    date_grouping_query = if ActiveRecord::Base.connection.adapter_name.downcase.include?('sqlite')
                            "strftime('%Y-%m', created_at)"
                          else
                            "TO_CHAR(created_at, 'YYYY-MM')"
                          end

    grouped_savings = where(user: user)
                      .group(date_grouping_query)
                      .select("#{date_grouping_query} as month, SUM(amount * price_per_kg) as total_savings")
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
