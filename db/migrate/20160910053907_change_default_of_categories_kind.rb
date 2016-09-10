class ChangeDefaultOfCategoriesKind < ActiveRecord::Migration
  def up
    change_column :categories, :kind, :integer, default: 0
  end

  def down
  end
end
