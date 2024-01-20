class CreateSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :schedules do |t|
      t.text :details
      t.references :vegetable, null: false, foreign_key: true

      t.timestamps
    end
  end
end
