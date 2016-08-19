class Post < ActiveRecord::Base

  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  mount_uploader :image, PostImageUploader

  belongs_to :author, class_name: 'User'

  validates :title, presence: true, length: { maximum: 255 }
  validates :content, presence: true
  validates :image, presence: true, file_content_type: { allow: /^image\/.*/ }

  scope :published, -> { where(published: true) }
end
