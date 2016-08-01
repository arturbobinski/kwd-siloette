class CreditCard < ActiveRecord::Base

  acts_as_paranoid

  belongs_to :user
  has_many :payments, as: :source

  validates :month, :year, numericality: { only_integer: true }
  validates :cc_type, :last_digits, :customer_profile_id, :payment_profile_id, presence: true

  after_save :ensure_one_default

  def self.from_stripe_token(stripe_token, user)
    email = user.email

    customer = Stripe::Customer.create(
      email: user.email,
      description: user.name,
      source: stripe_token
    )

    info = customer.sources.data.first

    if card = user.credit_cards.find_by(payment_profile_id: info.id)
      card.update(default: true) unless card.default
    else
      card = create(
        user:                 user,
        name:                 info.name,
        cc_type:              info.brand,
        month:                info.exp_month,
        year:                 info.exp_year,
        last_digits:          info.last4,
        customer_profile_id:  info.customer,
        payment_profile_id:   info.id,
        default:              true
      )
    end
    card
  rescue Stripe::CardError => e
    card = new
    card.errors.add :base, e.message
    card
  rescue Stripe::StripeError => e
    card = new
    card.errors.add :base, e.message
    card
  end

  def to_s
    [cc_type, "ending with #{last_digits}"].join(' ')
  end

  private

  def ensure_one_default
    if self.user_id && self.default
      CreditCard.where(default: true).where.not(id: self.id).where(user_id: self.user_id).each do |ucc|
        ucc.update_columns(default: false)
      end
    end
  end
end
