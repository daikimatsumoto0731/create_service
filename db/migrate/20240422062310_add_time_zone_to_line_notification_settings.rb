class AddTimeZoneToLineNotificationSettings < ActiveRecord::Migration[7.0]
  def change
    add_column :line_notification_settings, :time_zone, :string, default: 'Asia/Tokyo'
  end
end
