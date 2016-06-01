class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :zipcode
      t.decimal :price
      t.string :name
      t.text :description
      t.integer :user_id

      t.timestamps
    end

    add_index :places, :user_id
  end
end
