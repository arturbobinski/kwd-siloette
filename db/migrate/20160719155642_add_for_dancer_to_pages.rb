class AddForDancerToPages < ActiveRecord::Migration
  def change
    add_column :pages, :for_dancer, :boolean, default: false
  end
end
