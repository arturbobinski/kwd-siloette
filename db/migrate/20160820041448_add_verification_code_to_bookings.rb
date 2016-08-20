class AddVerificationCodeToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :verification_code, :integer
  end
end
