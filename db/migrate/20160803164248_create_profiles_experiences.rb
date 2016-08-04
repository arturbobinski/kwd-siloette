class CreateProfilesExperiences < ActiveRecord::Migration
  def change
    create_table :profiles_experiences do |t|
      t.integer :profile_id
      t.integer :experience_id
    end

    add_index :profiles_experiences, :profile_id
    add_index :profiles_experiences, :experience_id
  end
end
