class AddAlcoholAwarenessTrainingToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :alcohol_awareness_training, :string
  end
end
