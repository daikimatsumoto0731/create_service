# frozen_string_literal: true

class AddLineAuthInfoToLineNotificationSettings < ActiveRecord::Migration[7.0]
  def change
    add_column :line_notification_settings, :line_auth_info_api_key, :string
    add_column :line_notification_settings, :line_auth_info_user_id, :string
  end
end
