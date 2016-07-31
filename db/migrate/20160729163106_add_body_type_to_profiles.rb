class AddBodyTypeToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :body_type, :string
  end
end
