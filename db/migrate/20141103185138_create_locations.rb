class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :address

      t.float :latitude
      t.float :longitude

      #fk
      t.integer :restaurant_id

      t.timestamps
    end
  end
end
