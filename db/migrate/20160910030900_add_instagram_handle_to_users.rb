class AddInstagramHandleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :instagram_handle, :string
  end
end
