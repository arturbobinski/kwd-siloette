class ServiceImage < ActiveRecord::Base

  MAX_ATTACHMENT_SIZE = 3.megabytes

  mount_uploader :file, ServiceImageUploader

  belongs_to :service
  belongs_to :author, class_name: 'User'

  validates :file, presence: true, file_size: { less_than_or_equal_to: MAX_ATTACHMENT_SIZE.to_i }, file_content_type: { allow: /^image\/.*/ }

  def uploaded?
    !!file.file
  end
end
