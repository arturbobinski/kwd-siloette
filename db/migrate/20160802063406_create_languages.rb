class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.string :code
      t.string :name
      t.string :native_name
      t.boolean :active,      default: false
    end
  end
end
