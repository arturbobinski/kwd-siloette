class ChangeAccountNumberInUsers < ActiveRecord::Migration
  def change
    def up
      change_column :users, :account_number, :string
    end

    def down
    end
  end
end
