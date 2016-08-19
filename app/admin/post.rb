ActiveAdmin.register Post do

  permit_params :title, :content, :image, :author_id, :published

  form do |f|
    f.inputs 'Post Details' do
      f.hidden_field :author_id, value: current_user.id
      f.input :title
      f.input :image
      f.input :content, as: :ckeditor
      f.input :published
    end
    f.actions
  end
end
