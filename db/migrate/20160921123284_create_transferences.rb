class CreateTransferences < ActiveRecord::Migration
  def change
    create_table :transferences do |t|
      t.integer :user_id
      t.integer :booking_id
      t.integer :amount_cents
      t.string :currency
      t.string :transaction_id
      t.string :transfer_id
      t.string :status
      t.text :response_message
      t.text :info

      t.timestamps null: false
    end

    add_index :transferences, :user_id
    add_index :transferences, :booking_id
  end
end
