class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :address
      t.string :country
      t.string :postal_code
      t.float :lat
      t.float :lng
      t.string :location_type
      t.integer :owner_id
      t.string :owner_type
      t.datetime :deleted_at

      t.timestamps null: false
    end

    add_index :locations, [:owner_id, :owner_type]
    add_index :locations, :deleted_at
  end
end
