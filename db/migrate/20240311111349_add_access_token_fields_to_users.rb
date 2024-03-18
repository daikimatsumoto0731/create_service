# frozen_string_literal: true

class AddAccessTokenFieldsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :access_token, :string
    add_column :users, :token_expires_at, :datetime
  end
end
