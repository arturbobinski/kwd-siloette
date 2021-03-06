class Country < ActiveRecord::Base

  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  has_many :states, -> { order(name: :asc) }, dependent: :destroy

  validates :name, :iso_name, presence: true

  def self.default
    find_by!(iso: 'US')
  end

  def <=>(other)
    name <=> other.name
  end

  def to_s
    name
  end
end
