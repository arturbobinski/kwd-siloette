class CreateServiceImages < ActiveRecord::Migration
  def change
    create_table :service_images do |t|
      t.integer :service_id
      t.integer :author_id
      t.string :file
      t.boolean :profile,       default: false
      t.integer :width
      t.integer :height
      t.datetime :deleted_at

      t.timestamps null: false
    end

    add_index :service_images, :service_id
    add_index :service_images, :author_id
    add_index :service_images, :deleted_at
  end
end
