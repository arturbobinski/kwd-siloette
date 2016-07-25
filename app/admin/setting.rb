ActiveAdmin.register Setting do

  permit_params :var, :value

  index do
    selectable_column
    id_column
    column :var
    column :value
    column :created_at
    actions
  end

  filter :var
  filter :value

  form do |f|
    f.inputs 'Setting Details' do
      f.input :var
      f.input :value
    end
    f.actions
  end

end
