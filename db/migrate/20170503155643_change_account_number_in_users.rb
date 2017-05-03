class ChangeAccountNumberInUsers < ActiveRecord::Migration
  def change
    def up
      add_column :users, :account_number, :integer
    end

    def down
      remove_column :users, :account_number, :string
    end
  end
end
