ActiveAdmin.register User do

  permit_params :email, :first_name, :last_name, :password, :password_confirmation, :role, :description

  index do
    selectable_column
    id_column
    column :email
    column :name
    column :role
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :first_name
  filter :last_name
  filter :role, as: :select, collection: User.roles
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs 'User Details' do
      f.hidden_field :is_admin, value: true
      f.input :email
      f.input :first_name
      f.input :last_name
      f.input :role
      f.input :description
    end
    f.actions
  end

end
