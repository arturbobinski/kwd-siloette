ActiveAdmin.register Booking do

  permit_params :email, :event_type_id, :venue_type_id, :performer_id, :service_id, :start_at, :number_of_guests, :special_info

  index do
    column :user
    column :performer
    column :service
    column :start_at
    column :number_of_guests
    column :hours
    column :state
    column :payment_state
    column :total do |booking|
      number_to_currency booking.total
    end
    actions
  end

  filter :user
  filter :performer
  filter :state
  filter :payment_state
end
