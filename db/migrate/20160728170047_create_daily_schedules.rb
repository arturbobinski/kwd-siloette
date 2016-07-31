class CreateDailySchedules < ActiveRecord::Migration
  def change
    create_table :daily_schedules do |t|
      t.integer :user_id
      t.integer :wday
      t.integer :start_slot
      t.integer :end_slot
      t.boolean :active,        default: true

      t.timestamps null: false
    end

    add_index :daily_schedules, :user_id
    add_index :daily_schedules, :wday
    add_index :daily_schedules, :active
  end
end
