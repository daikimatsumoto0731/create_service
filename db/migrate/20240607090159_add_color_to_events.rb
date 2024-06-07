class AddColorToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :color, :string
  end
end
