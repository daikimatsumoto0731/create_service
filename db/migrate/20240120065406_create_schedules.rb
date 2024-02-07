class CreateSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :schedules do |t|
      t.string :title, null: false
      t.text :body
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.references :vegetable, null: false, foreign_key: true

      t.timestamps
    end
  end
end
