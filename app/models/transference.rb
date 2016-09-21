class Transference < ActiveRecord::Base

  monetize :amount_cents,
    allow_nil: false,
    numericality: {
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 1000000
    }

  serialize :info

  belongs_to :user
  belongs_to :booking

  validates_presence_of :user, :booking

  before_validation :prepare
  after_create :transfer

  private

  def prepare
    self.user = booking.performer
    self.amount_cents = booking.amount_cents
    self.currency = booking.currency
  end

  def transfer
    res = Stripe::Transfer.create(
      amount:         amount_cents,
      currency:       currency,
      destination:    user.connected_stripe_account_id,
      description:    "Payment for Booking ##{booking.token}"
    )
    self.status = res.status
    self.transaction_id = res.id
    self.info = res
    self.save
  rescue Stripe::InvalidRequestError => e
    self.update response_message: e
    return false
  end
end
