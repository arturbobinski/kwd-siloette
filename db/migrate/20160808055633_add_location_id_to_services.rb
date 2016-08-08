class AddLocationIdToServices < ActiveRecord::Migration
  def change
    add_column :services, :location_id, :integer
    add_index :services, :location_id
  end
end
