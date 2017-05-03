class AddRoutingNumberAndAccountNumberToProfiles < ActiveRecord::Migration
  def change
    add_column :users, :routing_number, :string
    add_index :users, :routing_number
    add_column :users, :account_number, :integer
    add_index :users, :account_number
  end
end
