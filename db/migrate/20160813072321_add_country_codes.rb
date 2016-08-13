class AddCountryCodes < ActiveRecord::Migration
  def change
    add_column :profiles, :country_code, :string
    add_column :addresses, :country_code, :string
  end
end
