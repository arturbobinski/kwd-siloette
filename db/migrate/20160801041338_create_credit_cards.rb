class CreateCreditCards < ActiveRecord::Migration
  def change
    create_table :credit_cards do |t|
      t.integer :user_id
      t.string :name
      t.string :month
      t.string :year
      t.string :cc_type
      t.string :last_digits
      t.string :customer_profile_id
      t.string :payment_profile_id
      t.boolean :default,             default: false
      t.datetime :deleted_at

      t.timestamps null: false
    end

    add_index :credit_cards, :user_id
    add_index :credit_cards, :payment_profile_id
    add_index :credit_cards, :deleted_at
  end
end
