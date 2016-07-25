ActiveAdmin.register Page do

  permit_params :title, :body, :slug, :active, :for_dancer

  index do
    selectable_column
    id_column
    column :title
    column :slug
    column :active
    column :for_dancer
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
      f.input :body, input_html: { class: 'ckeditor' }
      f.input :active
      f.input :for_dancer
    end
    f.actions
  end

end
