# frozen_string_literal: true

class AddUserIdToHarvests < ActiveRecord::Migration[7.0]
  def change
    add_reference :harvests, :user, null: true, foreign_key: true
  end
end
