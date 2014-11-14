class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.string :email
      t.string :name
      t.string :password_hash
      t.string :description

      t.timestamps
    end
  end
end
