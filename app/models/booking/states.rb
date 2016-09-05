module Booking::States
  extend ActiveSupport::Concern

  included do
    aasm column: :state do
      state :scheduling, initial: true
      state :address, :payment, :pending, :accepted, :declined, :canceled, :paid, :verified, :completed

      event :schedule do
        transitions from: [:address, :payment], to: :scheduling
      end

      event :locate do
        transitions from: [:scheduling, :payment], to: :address
      end

      event :checkout do
        transitions from: [:address], to: :payment
      end

      event :authorize, after: :notify do
        transitions from: :payment, to: :pending, guards: :payable?
      end

      event :accept, after: [:notify, :process_payment] do
        transitions from: :pending, to: :accepted, guards: :payable?
      end

      event :pay do
        transitions from: :accepted, to: :paid, guards: :payable?
      end

      event :decline, after: :notify do
        transitions from: :pending, to: :declined
      end

      event :verify, after: [:notify, :transfer_payment] do
        transitions from: :paid, to: :verified
      end

      event :complete do
        transitions from: :verified, to: :completed
      end

      event :cancel, after: :notify do
        transitions from: [:address, :payment, :pending], to: :canceled
      end
    end
  end
end