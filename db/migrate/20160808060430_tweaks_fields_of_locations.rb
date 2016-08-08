class TweaksFieldsOfLocations < ActiveRecord::Migration
  def up
    add_column :locations, :active, :boolean, default: false
    add_index :locations, :active
    remove_index :locations, [:owner_id, :owner_type]
    remove_column :locations, :owner_id
    remove_column :locations, :owner_type
    remove_index :locations, :deleted_at
    remove_column :locations, :deleted_at
    add_index :locations, :address
  end

  def down
    remove_index :locations, :active
    remove_column :locations, :active
    add_column :locations, :owner_id, :integer
    add_column :locations, :owner_type, :string
    add_index :locations, [:owner_id, :owner_type]
    add_column :locations, :deleted_at, :datetime
    add_index :locations, :deleted_at
    remove_index :locations, :address
  end
end
