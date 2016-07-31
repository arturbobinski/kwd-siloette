class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.integer :user_id
      t.datetime :start_at
      t.datetime :end_at

      t.timestamps null: false
    end

    add_index :reservations, :user_id
    add_index :reservations, :start_at
    add_index :reservations, :end_at
  end
end
