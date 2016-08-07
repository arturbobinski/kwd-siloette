class AddFieldsToTestimonials < ActiveRecord::Migration
  def change
    add_column :testimonials, :delay, :integer
    add_column :testimonials, :accuracy, :integer
    add_column :testimonials, :satisfaction, :integer
  end
end
