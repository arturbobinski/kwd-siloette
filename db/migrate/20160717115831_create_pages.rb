class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title
      t.text :body
      t.string :slug
      t.boolean :active, default: true

      t.timestamps null: false
    end

    add_index :pages, :slug
    add_index :pages, :active
  end
end
