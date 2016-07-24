class ServiceInvitation < ActiveRecord::Base

  enum status: %i(pending accepted declined)

  belongs_to :service, touch: true
  belongs_to :user

  after_save :update_counter_cache
  before_destroy :decrease_counter_cache
  after_create :send_invitaton_email

  private

  def update_counter_cache
    service.update_column(:performers_count, service.performers.count)
  end

  def decrease_counter_cache
    if accepted?
      service.decrement!(:performers_count)
    end
  end

  def send_invitaton_email
    return if user == service.user
    UserMailer.service_invitation_email(user, service).deliver_now
  end
  handle_asynchronously :send_invitaton_email
end
