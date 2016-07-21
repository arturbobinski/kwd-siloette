class ServiceInvitation < ActiveRecord::Base

  enum status: %i(pending accepted declined)

  belongs_to :service, touch: true
  belongs_to :user
end
