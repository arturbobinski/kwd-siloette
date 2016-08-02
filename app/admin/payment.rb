ActiveAdmin.register Payment do

  permit_params :state

  index do
    id_column
    column :booking
    column :amount
    column :fee
    column :total
    column :state
    column :message do |payment|
      payment.cvv_response_message
    end
    actions
  end

  filter :state
end
