class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.integer :user_id
      t.string :provider
      t.string :uid
      t.string :username
      t.string :token
      t.string :secret

      t.timestamps null: false
    end

    add_index :authentications, :user_id
    add_index :authentications, [:provider, :uid]
  end
end
