class AddAccessCodeToStations < ActiveRecord::Migration[6.0]
  def change
    add_column :stations, :access_code, :string
  end
end
