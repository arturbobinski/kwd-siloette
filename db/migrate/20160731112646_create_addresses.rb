class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :address1
      t.string :address2
      t.string :city
      t.string :zipcode
      t.integer :country_id
      t.string :state_name
      t.integer :state_id

      t.timestamps null: false
    end
  end
end
