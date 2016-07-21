class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin?
      can :manage, :all
    else
      can :read, User
      can [:edit, :update, :become_dancer], User, id: user.id

      can :read, Service

      can :read, Page

      if user.dancer?
        can [:create], Service
        can [:manage], Service, user_id: user.id
      end
    end
  end
end
