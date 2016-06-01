class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.integer :user_id
      t.integer :place_id
      t.datetime :starts_at
      t.datetime :ends_at

      t.timestamps
    end

    add_index :reservations, [:user_id, :place_id]
  end
end
