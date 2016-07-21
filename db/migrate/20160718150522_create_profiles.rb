class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.integer :user_id
      t.string :perform_name
      t.date :birth_date
      t.string :phone_number
      t.integer :ethnicity
      t.integer :bust
      t.float :weight
      t.float :height
      t.datetime :deleted_at

      t.timestamps null: false
    end

    add_index :profiles, :user_id
    add_index :profiles, :deleted_at
  end
end
