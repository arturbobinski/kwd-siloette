class AddPageTypeToPages < ActiveRecord::Migration
  def change
    remove_column :pages, :for_dancer, :boolean
    add_column :pages, :page_type, :integer, default: 0
    add_index :pages, :page_type
  end
end
