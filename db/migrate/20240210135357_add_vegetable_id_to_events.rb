class AddVegetableIdToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :vegetable_id, :integer
    add_index :events, :vegetable_id
  end
end
