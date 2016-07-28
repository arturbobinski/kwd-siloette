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

  attr_accessor :accept_terms, :is_admin

  has_one :profile, dependent: :destroy
  has_one :location, as: :owner, dependent: :destroy
  has_many :services, dependent: :destroy
  has_many :invitations, class_name: 'ServiceInvitation', dependent: :destroy
  has_many :pending_invitations, -> { pending }, class_name: 'ServiceInvitation'
  has_many :invited_services, through: :pending_invitations, source: :service
  has_many :accepted_invitations, -> { accepted }, class_name: 'ServiceInvitation'
  has_many :performing_services, through: :accepted_invitations, source: :service
  has_many :service_images, foreign_key: :author_id
  has_many :profile_images, -> { where(profile: true) }, foreign_key: :author_id, class_name: 'ServiceImage'
  has_many :authentications, dependent: :destroy

  delegate :perform_name, :height, :weight, :bust, :ethnicity, :phone_number, to: :profile
  delegate :address, to: :location

  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, length: { maximum: 50 }
  validates :role, inclusion: { in: User.roles.keys[0..-2] }, if: 'is_admin.blank?'
  validates :description, length: { maximum: 250 }
  validates :avatar, file_size: { less_than_or_equal_to: MAX_AVATAR_SIZE.to_i }, file_content_type: { allow: /^image\/.*/ }
  validate :acceptance_terms, on: :create

  accepts_nested_attributes_for :profile, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :location, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :service_images, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :authentications, reject_if: :all_blank, allow_destroy: true

  def self.from_omniauth(auth)
    if authentication = Authentication.where(provider: auth.provider, uid: auth.uid).first
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
          '0' => {
            provider: auth.provider,
            uid: auth.uid,
            token: auth.credentials.token,
            secret: auth.credentials.try(:secret),
            username: auth.info.try(:nickname)
          }
        }
        u.is_admin = true
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

  def acceptance_terms
    return true if is_admin
    unless accept_terms && accept_terms == '1'
      errors.add :accept_terms, I18n.t('activerecord.errors.models.user.attributes.accept_terms.blank')
    end
  end
end
