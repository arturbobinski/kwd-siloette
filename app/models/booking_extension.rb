class BookingExtension < ActiveRecord::Base

  acts_as_paranoid

  monetize :total_cents, :fee_cents, :amount_cents,
    allow_nil: false,
    numericality: {
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 1000000
    }

  belongs_to :booking
  has_one :payment, as: :payable, dependent: :destroy

  delegate :address, :service, :performer, :user, :token, :booking_price, :price_cents, to: :booking

  validates :hours, presence: true, numericality: { only_integer: true, greater_than: 0 }, on: :create
  validates_datetime :start_at, after: lambda { 2.hour.from_now }, on: :create
  validates_datetime :end_at, after: :start_at, on: :create

  before_validation :prepare, if: 'amount_cents.blank?'
  after_create :pay_extra

  scope :recent, -> { order(start_at: :desc) }
  scope :paid, -> { where(payment_state: 'completed') }

  def pay!
  end

  def metadata
    "ex#{token}"
  end

  def description
    "Payment on #{hours} hours extension of #{service.slug}"
  end

  private

  def prepare
    self.start_at = booking.last_end_at.in_time_zone(ActiveSupport::TimeZone[user.time_zone])
    self.end_at = self.start_at + hours.to_i.hours
    self.total_cents = booking_price * 100 * hours
    self.fee_cents = (price_cents * (Setting.commission_from_seller.to_f) / 100 * hours).round
    self.amount_cents = total_cents - fee_cents
    self.currency = 'usd'
  end

  def pay_extra
    if payment = create_payment(source: booking.payment.source, state: :authorized)
      payment.process!
    else
      errors.add :base, payment.errors.full_messages.join(' ')
    end
  end
end
