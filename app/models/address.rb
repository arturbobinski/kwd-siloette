class Address < ActiveRecord::Base

  belongs_to :country
  belongs_to :state
  has_many :bookings

  validates :country, presence: true
  validates :first_name, :last_name, presence: true, length: { maximum: 50 }
  validates :address1, :city, presence: true, length: { maximum: 255 }
  validates :phone, presence: true, format: { with: Regexp.new("\\A#{AppConfig.patterns[:phonenumber]}\\z") }
  validates :zipcode, presence: true, length: { maximum: 10 },
    format: { with: Regexp.new("\\A#{AppConfig.patterns[:zipcode]}\\z") }
  validate :state_validate

  scope :recent, -> { order(updated_at: :desc) }

  def self.build_default
    new country: Country.find_by(iso: 'US')
  end

  def self.from_attributes(attrs)
    if attrs[:id]
      address = Address.find(attrs[:id])
      attrs_without_id = attrs.except(:id)
      address.assign_attributes attrs_without_id
      if address.changed?
        address = Address.create(attrs_without_id)
      else
        address
      end
    else
      address = Address.create(attrs)
    end
  end

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def full_address
    [address1, address2, city].reject(&:blank?).join(' ')
  end

  def state_text
    state.try(:abbr) || state.try(:name) || state_name
  end

  def full_phone_number
    "#{country_code}#{phone.gsub(/(^0|\-|\(|\)|\s+)/, '')}"
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
