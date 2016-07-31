class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :iso_name
      t.string :iso
      t.string :iso3
      t.string :name
      t.integer :numcode
      t.boolean :states_required, default: false

      t.timestamps null: false
    end
  end
end
