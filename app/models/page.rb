class Page < ActiveRecord::Base

  extend FriendlyId
  friendly_id :slug, use: [:slugged, :finders]

  enum page_type: { general: 0, legal: 1, faq: 2, deals: 3, tips: 4 }

  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true

  scope :active, -> { where(active: true) }
  scope :for_dancer, -> { where(page_type: page_types.values_at(*Array(['deals', 'tips']))) }

  def for_dancer?
    deals? || tips?
  end
end
