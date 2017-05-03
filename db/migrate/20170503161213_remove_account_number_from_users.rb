class RemoveAccountNumberFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :account_number, :integer
  end
end
