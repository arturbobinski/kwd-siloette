class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin?
      can :manage, :all
    else
      can [:create], Booking
      can [:manage], Booking, user_id: user.id
      can [:new, :create], BookingExtension
      can :read, Page
      can :read, Post
      can :read, Service
      can [:new], Testimonial
      can [:create], Testimonial, author_id: user.id
      can [:read, :stripe_account, :apply], User
      can [:edit, :update, :become_dancer], User, id: user.id

      if user.dancer?
        can [:calendar], Booking
        can [:index, :show, :accept, :decline], Booking, performer_id: user.id
        can [:create], DailySchedule
        can [:manage], DailySchedule, user_id: user.id
        can [:create], Reservation
        can [:destroy], Reservation, user_id: user.id
        can [:create], Service
        can [:manage], Service, user_id: user.id
        can [:create], ServiceImage
        can [:update, :destroy], ServiceImage, author_id: user.id
        can [:media], User, id: user.id
      end
    end
  end
end
