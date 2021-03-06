class Service < ActiveRecord::Base

  include Localable

  acts_as_paranoid

  enum status: %i(active inactive)

  paginates_per 24

  monetize :price_cents, allow_nil: false,
    numericality: {
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 2000
    }

  attr_accessor :images_count

  belongs_to :user
  belongs_to :category

  has_many :invitations, class_name: 'ServiceInvitation', dependent: :destroy
  has_many :invitees, source: :user, through: :invitations
  has_many :accepted_invitations, -> { accepted }, class_name: 'ServiceInvitation'
  has_many :performers, source: :user, through: :accepted_invitations
  has_many :images, class_name: 'ServiceImage', dependent: :destroy
  has_one :primary_image, -> { order(:created_at) }, class_name: 'ServiceImage'
  has_one :video, as: :owner
  has_many :bookings, dependent: :destroy
  has_many :testimonials, dependent: :destroy

  delegate :address, :country, :lat, :lng, :postal_code, to: :location

  validates :category, presence: true
  validates :user, presence: true
  validates :description, presence: true, length: { maximum: 250 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :location, presence: true

  scope :open, -> { where(open: true) }
  scope :closed, -> { where(open: false) }
  scope :top_rated, -> { open.active.order(:rating) }
  scope :recent, -> { order(created_at: :desc) }

  before_validation :generate_title
  before_save :assign_ethnicity

  accepts_nested_attributes_for :images, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :invitations, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :video, reject_if: :all_blank, allow_destroy: true

  def slug
    "#{title} #{id}".parameterize
  end

  def booking_price
    price * (100 + (Setting.commission_from_seller.to_f - 5)) / 100
  end

  def performers_list
    performers.map(&:name).join(', ')
  end

  private

  def generate_title
    self.title = category.name
  end

  def assign_ethnicity
    self.ethnicity = user.ethnicity
  end
end
