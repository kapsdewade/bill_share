ActiveAdmin.register Role, :namespace => :super_admin do

  filter :name
  
  index do
    column :name
    default_actions
  end

  filter :email

  form do |f|
    f.inputs "Role Details" do
      f.input :name
    end
    f.buttons
  end
end
