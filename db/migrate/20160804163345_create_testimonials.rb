class CreateTestimonials < ActiveRecord::Migration
  def change
    create_table :testimonials do |t|
      t.integer :author_id
      t.text :text
      t.float :rating,        default: 0
      t.integer :service_id
      t.integer :receiver_id

      t.timestamps null: false
    end

    add_index :testimonials, :author_id
    add_index :testimonials, :service_id
    add_index :testimonials, :receiver_id
  end
end
