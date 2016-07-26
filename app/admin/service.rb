ActiveAdmin.register Service do

  permit_params :category_id, :description, :price, :status, :user_id, invitee_ids: [],
    location_attributes: [:id, :address, :country, :postal_code, :lat, :lng],
    images_attributes: [:id, :_destroy, :file, :file_cache],
    video_attributes: [:id, :link]

  index do
    selectable_column
    id_column
    column :show_type do |service|
      service.category
    end
    column :user
    column :description
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

  filter :category
  filter :user
  filter :open
end
