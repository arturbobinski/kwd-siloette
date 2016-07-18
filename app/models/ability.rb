class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin?
      can :manage, :all
    elsif user.dancer?
      can :manager, User, id: user.id
    else

    end
  end
end
