class AddNameToStations < ActiveRecord::Migration[6.0]
  def change
    add_column :stations, :name, :string
  end
end
