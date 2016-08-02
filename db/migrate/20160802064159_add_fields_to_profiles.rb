class AddFieldsToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :experience_level, :string
    add_column :profiles, :social_security_number, :string
    add_column :profiles, :education_level, :string
  end
end
