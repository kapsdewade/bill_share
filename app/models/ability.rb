class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.news

    if user.super_admin?
      can :manage, Role

      can :manage, User
      can :batch_action, User
      can :activate, User
      can :deactivate, User


    elsif user.admin?
      can :manage, User
      can [:read], Role
      
    elsif user.spartan?
      can :manage, User, id: user.id
    end  

  end
end
