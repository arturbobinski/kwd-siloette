class Payment < ActiveRecord::Base

  include AASM
  include TokenGenerator

  extend FriendlyId
  friendly_id :token, slug_column: :token, use: [:slugged, :finders]

  acts_as_paranoid

  monetize :amount_cents, :fee_cents, :total_cents,
    allow_nil: false,
    numericality: {
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 1000000
    }

  belongs_to :booking
  belongs_to :source, polymorphic: true

  before_validation :prepare, if: 'amount_cents.blank?'
  after_create :set_default_card

  scope :recent, -> { order(updated_at: :desc) }

  aasm column: :state do
    state :checkout, initial: true
    state :authorized, :completed, :processing, :failed

    after_all_transitions :update_booking_payment_state

    event :authorize, after: :authorize_booking do
      transitions from: [:checkout, :processing], to: :authorized
    end

    event :process, after: :charge do
      transitions from: [:authorized], to: :processing
    end

    event :failure, after: :notify_failure do
      transitions from: [:processing], to: :failed
    end

    event :complete, after: [:after_complete] do
      transitions from: [:processing], to: :completed
    end
  end

  def authorize_booking
    booking.authorize!
    update_booking_payment_state
  end

  def charge
    if chrg = Stripe::Charge.create({
        amount:           total_cents,
        currency:         booking.currency,
        customer:         source.customer_profile_id,
        application_fee:  fee_cents,
        description:      booking.service.slug,
        metadata:         { order_id: booking.token },
        destination:      booking.performer.connected_stripe_account_id
      })
      update response_code: chrg.id, cvv_response_message: nil
      complete!
    end
  rescue Stripe::CardError => e
    update response_code: nil, cvv_response_message: e.message
    failure!
  rescue Stripe::StripeError => e
    update response_code: nil, cvv_response_message: e.message
    failure!
  end

  def after_complete
    booking.pay!
    update_booking_payment_state
    notify_complete
  end

  def update_booking_payment_state
    booking.update_column :payment_state, aasm.current_state
  end

  def notify_complete
    UserMailer.payment_completed_email_to_user(self).deliver_later
    TwilioService.new.send_sms(booking.address.full_phone_number, 'Payment completed')
    UserMailer.payment_completed_email_to_performer(self).deliver_later
    TwilioService.new.send_sms(booking.performer.full_phone_number, 'Payment completed')
  end

  def notify_failure
    UserMailer.payment_failed_email_to_user(self).deliver_later
    TwilioService.new.send_sms(booking.address.full_phone_number, 'Payment failed')
  end

  private

  def prepare
    self.total_cents = booking.total_cents
    self.fee_cents = (booking.service.price_cents * (Setting.commission_from_seller.to_f) / 100 * booking.hours).round
    self.amount_cents = total_cents - fee_cents
  end

  def set_default_card
    source.update default: true
  end
end
