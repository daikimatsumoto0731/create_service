# frozen_string_literal: true

class AddNotificationTimeToLineNotificationSettings < ActiveRecord::Migration[7.0]
  def change
    add_column :line_notification_settings, :notification_time, :time
  end
end
