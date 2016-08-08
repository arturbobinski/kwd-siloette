class Location < ActiveRecord::Base

  validates :address, presence: true, length: { maximum: 255 }
  validates :lat, numericality: true, allow_blank: true
  validates :lng, numericality: true, allow_blank: true

  scope :active, -> { where(active: true) }
  scope :by_address, ->(address) { where('LOWER(address) LIKE ?', "%#{address.downcase.gsub(/-/, ' ')}%") }

  def self.from_attributes(attrs)
    location = Location.find_or_create_by(address: attrs[:address]) do |l|
      l.country = attrs[:country]
      l.lat = attrs[:lat]
      l.lng = attrs[:lng]
      l.postal_code = attrs[:postal_code] if attrs[:postal_code]
      l.active = attrs[:active] if attrs[:active]
    end
  end

  def locality
    address.split(',').first
  end

  def to_param
    locality.parameterize
  end
end
