class Page < ActiveRecord::Base

  extend FriendlyId
  friendly_id :slug, use: [:slugged, :finders]

  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true

  scope :active, -> { where(active: true) }
end
