class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.string :state
      t.integer :performer_id
      t.integer :user_id
      t.integer :service_id
      t.integer :event_type_id
      t.integer :venue_type_id
      t.integer :address_id
      t.string :email
      t.integer :number_of_guests,  default: 1
      t.datetime :start_at
      t.datetime :end_at
      t.text :special_info
      t.integer :hours
      t.integer :total_cents
      t.string :currency
      t.string :last_ip_address
      t.string :token
      t.string :payment_state
      t.datetime :deleted_at

      t.timestamps null: false
    end

    add_index :bookings, :performer_id
    add_index :bookings, :user_id
    add_index :bookings, :token
    add_index :bookings, :state
    add_index :bookings, :start_at
    add_index :bookings, :end_at
    add_index :bookings, :deleted_at
  end
end
