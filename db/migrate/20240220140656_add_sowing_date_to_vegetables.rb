# frozen_string_literal: true

class AddSowingDateToVegetables < ActiveRecord::Migration[7.0]
  def change
    add_column :vegetables, :sowing_date, :date
  end
end
