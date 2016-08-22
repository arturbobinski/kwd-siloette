class AddTotalHoursToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :total_hours, :integer
  end
end
