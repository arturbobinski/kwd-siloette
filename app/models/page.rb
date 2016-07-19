class Page < ActiveRecord::Base

  extend FriendlyId
  friendly_id :slug, use: [:slugged, :finders]

  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true

  scope :active, -> { where(active: true) }
  scope :general, -> { where(for_dancer: false) }
  scope :for_dancer, -> { where(for_dancer: true) }
end
