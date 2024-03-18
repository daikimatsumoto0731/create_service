# frozen_string_literal: true

class CreateHarvests < ActiveRecord::Migration[7.0]
  def change
    create_table :harvests do |t|
      t.decimal :amount
      t.string :vegetable_type
      t.decimal :price_per_kg

      t.timestamps
    end
  end
end
