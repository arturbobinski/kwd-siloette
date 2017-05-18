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


  controller do
     def update(options={}, &block)

      if resource.open
        UserMailer.send_service_open(User.find(resource.user_id)).deliver  
      else
        UserMailer.send_service_close(User.find(resource.user_id)).deliver  
      end
      
      super do |success, failure| 
        block.call(success, failure) if block
        failure.html { render :edit }
      end
     end
  end


  
  show do
    attributes_table do
      row :id
      row :performer do |service|
        link_to service.user.name, admin_user_path(service.user)
      end
      row :title
      row :description
      row :category
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
        ul do
          service.images.each do |img|
            li do
              image_tag img.file.url(:large)
            end
          end
        end
      end
    end
  end

  filter :category
  filter :user
  filter :open
end
