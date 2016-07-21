class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.integer :user_id
      t.string :title
      t.text :description
      t.integer :category_id
      t.boolean :open,              default: true
      t.integer :status,            default: 0
      t.float :rating,              default: 0
      t.integer :price_cents,       default: 0
      t.string :currency,           default: 'usd'
      t.integer :quantity,          default: 1
      t.integer :views_count,       default: 0
      t.integer :comments_count,    default: 0
      t.integer :performers_count,  default: 1
      t.integer :ethnicity
      t.datetime :deleted_at

      t.timestamps null: false
    end

    add_index :services, :user_id
    add_index :services, :category_id
    add_index :services, :open
    add_index :services, :status
    add_index :services, :rating
    add_index :services, :price_cents
    add_index :services, :performers_count
    add_index :services, :ethnicity
    add_index :services, :deleted_at
  end
end
