class Profile < ActiveRecord::Base

  acts_as_paranoid

  HEIGHTS = [4.9, 5.0, 5.1, 5.2, 5.3, 5.4, 5.5, 5.6, 5.7, 5.8, 5.9, 6.0, 6.1, 6.2, 6.3, 6.4]
  BODY_TYPES = ['Short/Petite', 'Short/Voluptuous', 'Athletic', 'Full Figure', 'Tall/Slim', 'Tall/Voluptuous']
  EXPERIENCE_LEVELS = ['Less than 1 year', '1-3 Years', '3-5 Years', 'More than 5 years']
  SOURCES = ['Another Performer', 'Google', 'Instagram', 'Twitter', 'Facebook', 'Friend']
  COMMUNING_PLANS = %w(own_car public_transport borrowed_car ride_sharing)
  # WEIGHTS = (90..210).step(10)

  enum ethnicity: %i(african_american asian caucasian eastern_asian first_nation latin_american middle_eastern
    pacific_islander other)
  # enum bust: %i(bee grape mandarin peach orange cantaloupe watermelon)

  belongs_to :user, touch: true
  has_and_belongs_to_many :experiences, join_table: :profiles_experiences
  has_and_belongs_to_many :languages, join_table: :profiles_languages

  delegate :instagram_handle, to: :user

  validates :perform_name, presence: true, length: { maximum: 20 }, if: 'user.verified?'#, uniqueness: { case_sensitive: false }
  validates :height, presence: true, inclusion: { in: HEIGHTS }, if: 'user.verified?'
  validates :body_type, presence: true, inclusion: { in: BODY_TYPES }, if: 'user.verified?'
  validates :experience_level, presence: true, inclusion: { in: EXPERIENCE_LEVELS }
  # validates :bust, presence: true, inclusion: { in: Profile.busts.keys }
  validates :ethnicity, presence: true, inclusion: { in: Profile.ethnicities.keys }, if: 'user.verified?'
  validates :education_level, length: { maximum: 255 }, if: 'user.verified?'
  validates :phone_number, presence: true, format: { with: Regexp.new("\\A#{AppConfig.patterns[:phonenumber]}\\z") }
  validates :social_security_number, presence: true, length: { maximum: 9 },
    format: { with: Regexp.new("\\A#{AppConfig.patterns[:social_security_number]}\\z") }
  validates :hear_from, inclusion: { in: SOURCES }, if: 'hear_from'
  validates :communing_plan, inclusion: { in: COMMUNING_PLANS }, if: 'communing_plan'

  scope :by_phone_number, ->(number) { where('CONCAT(country_code, phone_number) = ?', number) }

  after_save :update_services

  def full_phone_number
    "#{country_code}#{phone_number.gsub(/(^0|\-|\(|\)|\s+)/, '')}"
  end

  private

  def update_services
    user.services.update_all(ethnicity: self[:ethnicity])
  end
end
