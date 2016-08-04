module TokenGenerator
  extend ActiveSupport::Concern
  
  included do
    before_create :generate_token
  end

  private

  def generate_token
    self.token = loop do
      random_token = SecureRandom.random_number(1000000000).to_s
      break random_token unless self.class.exists?(token: random_token)
    end
  end
end