class AddPublishableKeyToAuthentications < ActiveRecord::Migration
  def change
    add_column :authentications, :publishable_key, :string
  end
end
