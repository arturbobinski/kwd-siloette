class ChangeBookingToPayableOfPayments < ActiveRecord::Migration
  def up
    remove_index :payments, :booking_id
    rename_column :payments, :booking_id, :payable_id
    add_column :payments, :payable_type, :string
    add_index :payments, [:payable_id, :payable_type]
  end

  def down
    remove_index :payments, [:payable_id, :payable_type]
    remove_column :payments, :payable_type
    rename_column :payments, :payable_id, :booking_id
    add_index :payments, :booking_id
  end
end
