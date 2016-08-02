class CreateProfilesLanguages < ActiveRecord::Migration
  def change
    create_table :profiles_languages do |t|
      t.integer :profile_id
      t.integer :language_id
    end

    add_index :profiles_languages, :profile_id
    add_index :profiles_languages, :language_id
  end
end
