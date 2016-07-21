class CreateServiceInvitations < ActiveRecord::Migration
  def change
    create_table :service_invitations do |t|
      t.integer :service_id
      t.integer :user_id
      t.integer :status,      default: 0

      t.timestamps null: false
    end

    add_index :service_invitations, :service_id
    add_index :service_invitations, :user_id
    add_index :service_invitations, :status
  end
end
