class Booking < ActiveRecord::Base

  include AASM
  include TokenGenerator

  extend FriendlyId
  friendly_id :token, slug_column: :token, use: [:slugged, :finders]

  acts_as_paranoid

  monetize :total_cents, allow_nil: false,
    numericality: {
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 1000000
    }

  attr_accessor :start_time, :end_time

  belongs_to :performer, class_name: 'User'
  belongs_to :user
  belongs_to :service
  belongs_to :event_type
  belongs_to :venue_type
  belongs_to :address

  has_many :payments, dependent: :destroy

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :payments

  validates_presence_of :performer, :user, :service, :event_type, :venue_type, :special_info
  validates :number_of_guests, numericality: { only_integer: true, greater_than: 0 }
  validates_datetime :start_at, after: lambda { 2.hour.from_now }
  validates_datetime :end_at, after: :start_at

  scope :by_date, ->(date) { where('DATE(start_at) = ?', date) }
  scope :recent, -> { order(created_at: :desc) }

  before_validation :prepare, unless: 'start_time.blank?'

  aasm column: :state do
    state :initial, initial: true
    state :address, :payment, :pending, :paying, :declined, :canceled, :completed

    event :initiate do
      transitions from: :initial, to: :address
    end

    event :locate do
      transitions from: :address, to: :payment
    end

    event :preauthorize, after: :notify_performer do
      transitions from: :payment, to: :pending, guards: :payable?
    end

    event :accept, after: :notify_booker do
      transitions from: :pending, to: :paying
    end

    event :decline, after: :notify_booker do
      transitions from: :pending, to: :declined
    end

    event :complete, after: [:notify_performer, :notify_booker] do
      transitions from: :paying, to: :completed, guards: :payable?
    end

    event :cancel, after: :notify_performer do
      transitions from: [:address, :payment, :pending], to: :canceled
    end
  end

  def payable?
    service && performer
  end

  def address_attributes=(attrs)
    if address
      address.update(attrs)
    else
      if addr = Address.create(attrs)
        self.address = addr
      else
        self.errors.add :base, addr.errors.full_mesages.join(' ')
      end
    end
  end

  private

  def prepare
    date = start_at.to_date
    self.start_at = date + start_time.to_i.hours
    self.end_at = date + end_time.to_i.hours
    self.hours = ((end_at - start_at) / 3600).round
    self.total_cents = service.booking_price * 100 * hours
    self.currency = 'usd'
  end

  def notify_performer
  end

  def notify_booker
  end
end
