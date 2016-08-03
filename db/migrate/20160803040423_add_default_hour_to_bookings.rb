class AddDefaultHourToBookings < ActiveRecord::Migration
  def change
    change_column :bookings, :hours, :integer, default: 1
  end
end
