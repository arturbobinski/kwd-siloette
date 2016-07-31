class Address < ActiveRecord::Base

  belongs_to :country
  belongs_to :state

  validates :country, presence: true
  validates :first_name, :last_name, presence: true, length: { maximum: 50 }
  validates :address1, :city, presence: true, length: { maximum: 255 }
  validates :phone, presence: true, length: { maximum: 20 },
    format: { with: Regexp.new("\\A#{AppConfig.patterns[:phonenumber]}\\z") }
  validates :zipcode, presence: true, length: { maximum: 10 },
    format: { with: Regexp.new("\\A#{AppConfig.patterns[:zipcode]}\\z") }
  validate :state_validate

  def self.build_default
    new country: Country.find_by(iso: 'US')
  end

  def full_name
    "#{firstname} #{lastname}".strip
  end

  def state_text
    state.try(:abbr) || state.try(:name) || state_name
  end

  def active_merchant_hash
    {
      name: full_name,
      address1: address1,
      address2: address2,
      city: city,
      state: state_text,
      zip: zipcode,
      country: country.try(:iso),
      phone: phone
    }
  end

  private

  def state_validate
    return if country.blank?
    return unless country.states_required

    if state.present?
      if state.country == country
        self.state_name = nil
      else
        if state_name.present?
          self.state = nil
        else
          errors.add(:state, :invalid)
        end
      end
    end

    if state_name.present?
      if country.states.present?
        states = country.states.find_all_by_name_or_abbr(state_name)

        if states.size == 1
          self.state = states.first
          self.state_name = nil
        else
          errors.add(:state, :invalid)
        end
      end
    end

    errors.add :state, :blank if state.blank? && state_name.blank?
  end
end
