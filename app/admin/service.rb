ActiveAdmin.register Service do

  permit_params :category_id, :description, :price, :status, :user_id, :open, invitee_ids: [],
    location_attributes: [:id, :address, :country, :postal_code, :lat, :lng],
    images_attributes: [:id, :_destroy, :file, :file_cache],
    video_attributes: [:id, :link]

  index do
    id_column
    column :image do |service|
      if service.primary_image
        image_tag service.primary_image.file.url(:small), width: 60
      end
    end
    column :show_type do |service|
      service.category
    end
    column :performer do |service|
      link_to service.user.name, admin_user_path(service.user)
    end
    column :price
    column :performers do |service|
      service.performers_count
    end
    column :location do |service|
      service.address
    end
    column :open
    column :status
    actions
  end
  
  show do
    attributes_table do
      row :id
      row link_to service.user.name, admin_user_path(service.user)
      row :title
      row :description
      row :open
      row :status
      row :rating
      row :price_cents
      row :currency
      row :quantity
      row :views_count
      row :comments_count
      row :performers_count
      row :ethnicity
      row :deleted_at
      row :created_at
      row :updated_at
      row :location
      row :image do |service|
        service.images.each do |img|
          image_tag(img.image.url(:small))
        end
      end
    end
  end

  filter :category
  filter :user
  filter :open
end
