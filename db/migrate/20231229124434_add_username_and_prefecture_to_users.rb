# frozen_string_literal: true

class AddUsernameAndPrefectureToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :username, :string
    add_column :users, :prefecture, :string
  end
end
