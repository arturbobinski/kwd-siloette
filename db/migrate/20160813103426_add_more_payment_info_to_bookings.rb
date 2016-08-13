class AddMorePaymentInfoToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :fee_cents, :integer
    add_column :bookings, :amount_cents, :integer
  end
end
