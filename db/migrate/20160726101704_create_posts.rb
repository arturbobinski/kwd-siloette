class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.integer :author_id
      t.string :slug
      t.boolean :published,       default: false

      t.timestamps null: false
    end

    add_index :posts, :slug
    add_index :posts, :author_id
    add_index :posts, :published
  end
end
