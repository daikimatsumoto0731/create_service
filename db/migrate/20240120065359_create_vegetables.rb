# frozen_string_literal: true

class CreateVegetables < ActiveRecord::Migration[7.0]
  def change
    create_table :vegetables do |t|
      t.string :name

      t.timestamps
    end
  end
end
