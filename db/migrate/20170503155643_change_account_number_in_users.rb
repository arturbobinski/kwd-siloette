class ChangeAccountNumberInUsers < ActiveRecord::Migration
  def change
    def up
      remove_column :users, :account_number, :integer
    end

    def down
      add_column :users, :account_number, :string
    end
  end
end
