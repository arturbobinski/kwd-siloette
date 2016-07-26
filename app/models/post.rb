class Post < ActiveRecord::Base

  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  belongs_to :author, class_name: 'User'

  validates :title, presence: true, length: { maximum: 255 }
  validates :content, presence: true

  scope :published, -> { where(published: true) }
end
