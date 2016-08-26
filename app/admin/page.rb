ActiveAdmin.register Page do

  permit_params :title, :body, :slug, :active, :page_type

  index do
    selectable_column
    id_column
    column :title
    column :slug
    column :active
    column :page_type
    column :created_at
    actions
  end

  filter :title
  filter :slug
  filter :created_at

  form do |f|
    f.inputs 'Page Details' do
      f.input :title
      f.input :slug
      f.input :body, as: :ckeditor
      f.input :page_type, as: :select, collection: Page.page_types.keys
      f.input :active
    end
    f.actions
  end

end
