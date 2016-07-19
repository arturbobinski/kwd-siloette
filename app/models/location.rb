class Location < ActiveRecord::Base

  belongs_to :owner, polymorphic: true

  validates :address, presence: true, length: { maximum: 255 }
  validates :lat, numericality: true, allow_blank: true
  validates :lng, numericality: true, allow_blank: true
end
