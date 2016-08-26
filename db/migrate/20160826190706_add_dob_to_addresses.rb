class AddDobToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :dob, :date
  end
end
