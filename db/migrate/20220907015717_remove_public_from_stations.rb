class RemovePublicFromStations < ActiveRecord::Migration[6.0]
  def change
    remove_column :stations, :public, :boolean
  end
end
