class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin?
      can :manage, :all
    else
      can :read, User
      can [:edit, :update], User, id: user.id

      can :read, Page
    end
  end
end
