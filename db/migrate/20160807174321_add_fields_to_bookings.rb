class AddFieldsToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :entry_instructions, :text
    add_column :bookings, :parking_instructions, :text
  end
end
