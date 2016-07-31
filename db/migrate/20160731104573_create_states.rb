class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.string :name
      t.string :abbr
      t.integer :country_id

      t.timestamps null: false
    end

    add_index :states, :country_id
  end
end
