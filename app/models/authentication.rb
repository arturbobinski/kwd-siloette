class Authentication < ActiveRecord::Base

  belongs_to :user

  after_create :update_handle

  private

  def update_handle
    user.update(instagram_handle: username) if provider == 'instagram'
  end
end
