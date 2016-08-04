class AddReferralCodeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :referral_code, :string
    add_index :users, :referral_code
    add_column :users, :referrer_id, :integer
    add_index :users, :referrer_id
  end
end
