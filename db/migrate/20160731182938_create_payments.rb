class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :booking_id
      t.integer :amount_cents
      t.integer :source_id
      t.string :source_type
      t.integer :payment_method_id
      t.string :state
      t.string :token
      t.string :response_code
      t.string :avs_response
      t.string :cvv_response_code
      t.string :cvv_response_message

      t.timestamps null: false
    end

    add_index :payments, :token
    add_index :payments, :booking_id
    add_index :payments, :state
    add_index :payments, [:source_id, :source_type]
    add_index :payments, :payment_method_id
  end
end
