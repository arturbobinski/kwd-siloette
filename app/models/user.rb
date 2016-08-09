class User < ActiveRecord::Base

  acts_as_paranoid
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]

  MAX_AVATAR_SIZE = 3.megabytes

  enum role: %i(customer dancer company admin)
  enum gender: %i(male female)

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :avatar, AvatarUploader

  attr_accessor :accept_terms, :consent_check, :referred_by, :is_admin

  belongs_to :referrer, class_name: 'User', foreign_key: :referrer_id
  belongs_to :location

  has_one :profile, dependent: :destroy
  has_many :services, dependent: :destroy
  has_many :invitations, class_name: 'ServiceInvitation', dependent: :destroy
  has_many :pending_invitations, -> { pending }, class_name: 'ServiceInvitation'
  has_many :invited_services, through: :pending_invitations, source: :service
  has_many :accepted_invitations, -> { accepted }, class_name: 'ServiceInvitation'
  has_many :performing_services, through: :accepted_invitations, source: :service
  has_many :service_images, foreign_key: :author_id
  has_many :profile_images, -> { where(profile: true) }, foreign_key: :author_id, class_name: 'ServiceImage'
  has_many :authentications, dependent: :destroy
  has_many :schedules, class_name: 'DailySchedule', dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :received_bookings, foreign_key: :performer_id, class_name: 'Booking', dependent: :destroy
  has_many :reservations, dependent: :destroy
  has_many :credit_cards, dependent: :destroy
  has_many :addresses, through: :bookings
  has_many :referrals, class_name: 'User', foreign_key: :referrer_id
  has_many :testimonials, foreign_key: :author_id, dependent: :destroy
  has_many :received_feedbacks, foreign_key: :receiver_id, class_name: 'Testimonial', dependent: :destroy

  delegate :perform_name, :height, :weight, :ethnicity, :phone_number, to: :profile
  delegate :address, to: :location

  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, length: { maximum: 50 }
  validates :role, inclusion: { in: User.roles.keys[0..-2] }, if: 'is_admin.blank?'
  validates :description, length: { maximum: 250 }
  validates :avatar, file_size: { less_than_or_equal_to: MAX_AVATAR_SIZE.to_i }, file_content_type: { allow: /^image\/.*/ }
  # validate :acceptance_terms, on: :create
  validates_date :birth_date, allow_blank: true

  accepts_nested_attributes_for :profile, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :location, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :service_images, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :authentications, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :schedules, reject_if: :all_blank, allow_destroy: true

  after_validation :set_referrer, if: 'referred_by'
  before_create :generate_referral_code
  after_update :send_verified_mail

  scope :dancer_with_profile, -> { dancer.joins(:profile).group('users.id').having('count(user_id) > 0') }

  def self.from_omniauth(auth, user=nil)
    attrs = {
      username: auth.info.try(:nickname),
      token: auth.credentials.token,
      secret: auth.credentials.try(:secret),
      publishable_key: auth.info.try(:stripe_publishable_key)
    }

    if user
      if authentication = user.authentications.where(provider: auth.provider, uid: auth.uid).first
        authentication.update(attrs)
      else
        user.authentications.create(attrs.merge(provider: auth.provider, uid: auth.uid))
      end
      user
    elsif authentication = Authentication.where(provider: auth.provider, uid: auth.uid).first
      authentication.update(token: auth.credentials.token, secret: auth.credentials.try(:secret))
      authentication.user
    else
      email = auth.info.email || "#{auth.info.try(:nickname)}@#{auth.provider}.com"
      password = Devise.friendly_token[0, 20]

      user = where(email: email).first_or_create do |u|
        u.password = password
        u.password_confirmation = password
        u.name = auth.info.name
        u.remote_avatar_url = auth.info.image.gsub('http://', 'https://')
        u.birth_date = auth.extra.raw_info.try(:birthday)
        u.gender = auth.extra.raw_info.try(:gender)
        u.authentications_attributes = {
          '0' => attrs.merge(provider: auth.provider, uid: auth.uid)
        }
      end

      user
    end
  end

  def name
    [first_name, last_name].reject(&:blank?).join(' ')
  end

  def name=(value)
    splitted = value.split(' ')
    self.first_name = splitted.first
    self.last_name = splitted[1..-1].join(' ')
  end

  def slug_candidates
    [
      :name,
      [:name, :email],
    ]
  end

  def connected_stripe_account
    authentications.where(provider: 'stripe_connect').first
  end

  def connected_stripe_account_id
    connected_stripe_account.uid
  end

  def payment_ready?
    !connected_stripe_account.nil?
  end

  def profile_ready?
    profile&.body_type
  end

  def location_attributes=(attrs)
    if (loc = Location.from_attributes(attrs)).persisted?
      self.location = loc
    else
      errors.add :base, loc.errors.full_mesages.join(' ')
    end
  end

  private

  def acceptance_terms
    return true if is_admin
    unless accept_terms && accept_terms == '1'
      errors.add :accept_terms, I18n.t('activerecord.errors.models.user.attributes.accept_terms.blank')
    end
  end

  def generate_referral_code
    self.referral_code = loop do
      random_code = SecureRandom.hex(6)
      break random_code unless self.class.exists?(referral_code: random_code)
    end
  end

  def set_referrer
    self.referrer = User.find_by(referral_code: referred_by)
  end

  def send_verified_mail
    UserMailer.user_verified_mail(self).deliver_later if (verified_changed? && verified?)
  end
end
