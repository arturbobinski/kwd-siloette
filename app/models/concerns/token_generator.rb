module TokenGenerator
  extend ActiveSupport::Concern
  
  included do
    before_create :create_token
  end

  private

  def create_token
    loop do
      self.token = SecureRandom.random_number(1000000000).to_s
      break token unless self.class.exists?(token: token)
    end
  end
end