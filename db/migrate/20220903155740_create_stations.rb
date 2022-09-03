class CreateStations < ActiveRecord::Migration[5.2]
  def change
    create_table :stations do |t|
      t.string :address
      t.boolean :public
      t.references :location, foreign_key: true

      t.timestamps
    end
  end
end
