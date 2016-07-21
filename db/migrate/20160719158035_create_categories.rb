class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.string :description
      t.integer :kind, default: 1

      t.timestamps null: false
    end

    add_index :categories, :kind
  end
end
