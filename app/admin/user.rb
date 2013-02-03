ActiveAdmin.register User do     
  
  filter :name
  filter :email
  filter :role
  filter :state

  batch_action(:activate, :priority => 1) {}
  batch_action(:deactivate, :priority => 2) {}
  batch_action :destroy, false

  member_action :activate, :method => :get do
    @user = User.find(params[:id])
    if @user.activate!
      redirect_to admin_users_path, :notice => "User activated successfully" and return
    end
  end

  member_action :deactivate, :method => :get do
    @user = User.find(params[:id])
    if @user.deactivate!
      redirect_to admin_users_path, :notice => "User deactivated successfully" and return
    end
  end
  
  batch_action :deactivate, :confirm => "Are you sure you want to deactivate? All subtopics related to this topic will set to inactive state" do |collection_selection|
    users = User.find(collection_selection)

    users.each do |user|
      user.deactivate! unless user.inactive?
    end
    redirect_to admin_users_path, :notice =>"Users deactivated successfully."

  end

  batch_action :activate do |collection_selection|
    users = User.find(collection_selection)

    users.each do |user|
      user.activate! unless user.active?
    end
    redirect_to admin_users_path, :notice =>"Users activated successfully."

  end
  
  

  index do
    selectable_column
    column :name
    column :email
    column :role do |user|
      user.role.name
    end
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    column :state, :sortable =>:state do |user|
      status_tag user.state, user.status_tag
    end
    column do |user|
      if user == current_user || user.super_admin?
        link_to("View", admin_user_path(user)) + ' | ' + link_to("Edit", edit_admin_user_path(user))
      else
        if user.inactive?
          link_to("View", admin_user_path(user)) + " | " + link_to("Edit", edit_admin_user_path(user))  + " | " + link_to("Activate", activate_admin_user_path(user))
        else
          link_to("View", admin_user_path(user)) + " | " + link_to("Edit", edit_admin_user_path(user))  + " | " + link_to("Deactivate", deactivate_admin_user_path(user))
        end
      end
    end
    # default_actions
  end

  controller do
    before_filter :set_current_user, :only => [:batch_action, :activate, :deactivate]
    before_filter :authorize_admin

    authorize_resource
    include ActiveAdminCanCan

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
        redirect_to admin_users_path, :notice =>"User has been update successfully" and return
      end
    end

    def set_current_user
      # Set current_user ----> http://rails-bestpractices.com/posts/47-fetch-current-user-in-models
      User.current = current_user
    end


  end

  form do |f|
    f.inputs "Super Admin Details" do
      f.input :name
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :role_id, :as => :select, :collection => Role.find(:all, :conditions => ["id != ?", 1]).collect{|r| [r.name, r.id]}
    end
    f.buttons
  end                                
end                                   
