class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :title
      t.decimal :price
      t.string :description
      t.binary :picture

      #fk
      t.integer :restaurant_id
      t.integer :category_id

      t.timestamps
    end
  end
end
