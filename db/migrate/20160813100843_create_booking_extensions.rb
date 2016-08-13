class CreateBookingExtensions < ActiveRecord::Migration
  def change
    create_table :booking_extensions do |t|
      t.integer :booking_id
      t.datetime :start_at
      t.datetime :end_at
      t.integer :hours
      t.integer :total_cents
      t.integer :fee_cents
      t.integer :amount_cents
      t.string :currency
      t.string :payment_state
      t.datetime :deleted_at

      t.timestamps null: false
    end

    add_index :booking_extensions, :booking_id
    add_index :booking_extensions, :deleted_at
  end
end
