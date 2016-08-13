class AddDialCodeToCountries < ActiveRecord::Migration
  def change
    add_column :countries, :dial_code, :string
  end
end
