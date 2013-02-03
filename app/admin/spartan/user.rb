ActiveAdmin.register User, :namespace => :super_admin do     
  
  filter :name
  filter :email
  filter :role
  filter :state
  
  index do       
    column :name                     
    column :email
    column :state                     
    column :current_sign_in_at        
    column :last_sign_in_at           
    column :sign_in_count             
    default_actions                   
  end                                 

  controller do
    before_filter :authorize_super_admin
    
    def update
      update! do |format|
        if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
          params["user"].delete("password")
          params["user"].delete("password_confirmation")
        end
        user = User.find(params[:id])
        if  user.update_attributes(params[:user])
          sign_in(current_user, :bypass => true)
        end
        redirect_to spartan_users_path, :notice =>"User has been update successfully" and return
      end
    end
    
  end

  form do |f|                         
    f.inputs "Admin Details" do       
      f.input :name
      f.input :email                  
      f.input :password               
      f.input :password_confirmation  
    end                               
    f.buttons                         
  end                                 
end                                   
