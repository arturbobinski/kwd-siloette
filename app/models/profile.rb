class Profile < ActiveRecord::Base

  acts_as_paranoid

  HEIGHTS = [4.9, 5.0, 5.1, 5.2, 5.3, 5.4, 5.5, 5.6, 5.7, 5.8, 5.9, 6.0, 6.1, 6.2, 6.3, 6.4]
  BODY_TYPES = ['Short/Petite', 'Short/Voluptuous', 'Athletic', 'Full Figure', 'Tall/Slim', 'Tall/Voluptuous']
  # WEIGHTS = (90..210).step(10)

  enum ethnicity: %i(white black asian hispanic)
  enum bust: %i(bee grape mandarin peach orange cantaloupe watermelon)

  belongs_to :user, touch: true

  validates :perform_name, presence: true, length: { maximum: 20 }#, uniqueness: { case_sensitive: false }
  validates :height, presence: true, inclusion: { in: HEIGHTS }
  validates :body_type, presence: true, inclusion: { in: BODY_TYPES }
  validates :bust, presence: true, inclusion: { in: Profile.busts.keys }
  validates :ethnicity, presence: true, inclusion: { in: Profile.ethnicities.keys }
  validates :phone_number, presence: true, length: { maximum: 20 },
    format: { with: Regexp.new("\\A#{AppConfig.patterns[:phonenumber]}\\z") }

  after_save :update_services

  private

  def update_services
    user.services.update_all(ethnicity: self[:ethnicity])
  end
end
