class CreateVenueTypes < ActiveRecord::Migration
  def change
    create_table :venue_types do |t|
      t.string :name
      t.text :description

      t.timestamps null: false
    end
  end
end
