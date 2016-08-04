class AddApplyFieldsToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :eligible_in_us, :boolean, default: true
    add_column :profiles, :hear_from, :string
    add_column :profiles, :communing_plan, :string
  end
end
