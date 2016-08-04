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

  aasm column: :state do
    state :checkout, initial: true
    state :authorized, :completed, :processing, :failed

    after_all_transitions :update_booking_payment_state

    event :authorize, after: :authorize_booking do
      transitions from: [:checkout, :processing], to: :authorized
    end

    event :process, after: :charge do
      transitions from: [:checkout, :authorized, :completed], to: :processing
    end

    event :failure, after: :notify_failure do
      transitions from: [:authorized, :processing, :failure], to: :failed
    end

    event :complete, after: [:notify_complete] do
      transitions from: [:processing, :authorized, :checkout], to: :completed
    end
  end

  def authorize_booking
    booking.authorize!
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

  def update_booking_payment_state
    booking.update_column :payment_state, aasm.current_state
  end

  def notify_complete
    UserMailer.payment_completed_email_to_user(self).deliver_later
    TwilioService.new.send_sms(booking.address.phone, 'Payment completed')
    UserMailer.payment_completed_email_to_performer(self).deliver_later
    TwilioService.new.send_sms(booking.performer.phone_number, 'Payment completed')
  end

  def notify_failure
    UserMailer.payment_failed_email_to_user(self).deliver_later
    TwilioService.new.send_sms(booking.address.phone, 'Payment failed')
  end

  private

  def prepare
    self.amount_cents = (booking.service.price_cents * booking.hours).round
    self.fee_cents = (amount_cents * (Setting.commission_from_seller.to_i) / 100).round
    self.total_cents = booking.total_cents
  end
end
