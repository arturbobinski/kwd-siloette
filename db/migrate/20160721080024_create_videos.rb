class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :owner_type
      t.integer :owner_id
      t.integer :provider
      t.string :link
      t.datetime :deleted_at

      t.timestamps null: false
    end

    add_index :videos, [:owner_type, :owner_id]
    add_index :videos, :deleted_at
  end
end
