class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    logger.error 'CanCan error Below:'
    logger.error 'Error: ' + exception.message
    redirect_to "/", :notice => 'Sorry thats not a place for you :('
  end

  def authorize_super_admin
    raise CanCan::AccessDenied.new unless current_user.blank? || current_user.super_admin?
  end

  def authorize_admin
    raise CanCan::AccessDenied.new unless current_user.blank? || (current_user.admin?)
  end

  def authorize_spartan
    raise CanCan::AccessDenied.new unless current_user.blank? || (current_user.spartan?)
  end
  def current_ability
    @current_ability ||=Ability.new(current_user)
  end

  def after_sign_in_path_for(resource_or_scope)
    if current_user.super_admin?
       super_admin_dashboard_path
    elsif current_user.admin?
       admin_dashboard_path
    elsif current_user.spartan?
       spartan_dashboard_path
    end
  end
end
