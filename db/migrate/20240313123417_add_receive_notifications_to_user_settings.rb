class AddReceiveNotificationsToUserSettings < ActiveRecord::Migration[7.0]
  def change
    add_column :user_settings, :receive_notifications, :boolean, defalut: true
  end
end
