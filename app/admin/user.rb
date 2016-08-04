ActiveAdmin.register User do

  permit_params :email, :first_name, :last_name, :password, :password_confirmation, :role, :description,
    :is_admin, :verified, :referral_code

  index do
    selectable_column
    id_column
    column :email
    column :name
    column :role
    column :verified
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :first_name
  filter :last_name
  filter :role, as: :select, collection: User.roles
  filter :verified
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
      f.input :verified
    end
    f.actions
  end

  show do |user|
    default_main_content

    if user.profile
      panel 'Profile' do
        table_for user.profile do
          column :perform_name do |profile|
            profile.perform_name
          end
          column :phone_number
          column :ethnicity
          column :height
          column :body_type
          column :languages do |profile|
            profile.languages.pluck(:name).join(', ')
          end
          column :experiences do |profile|
            profile.experiences.pluck(:name).join(', ')
          end
          column :experience_level
          column :social_security_number
          column :education_level
          column :eligible_in_us
          column :hear_from
          column :communing_plan
        end
      end
    end
  end
end
