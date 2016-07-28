class MoveBirthDateToUsers < ActiveRecord::Migration
  def up
    add_column :users, :birth_date, :date

    User.reset_column_information
    User.dancer.find_each do |user|
      user.update birth_date: user.profile.birth_date if user.profile
    end

    remove_column :profiles, :birth_date
  end

  def down
    add_column :profiles, :birth_date, :date

    Profile.reset_column_information
    Profile.find_each do |profile|
      profile.update birth_date: profile.user.birth_date
    end

    remove_column :users, :birth_date
  end
end
