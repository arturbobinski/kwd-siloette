# encoding: utf-8
require 'carrierwave'

class CkeditorAttachmentFileUploader < BaseUploader
  include Ckeditor::Backend::CarrierWave

  def extension_white_list
    Ckeditor.attachment_file_types
  end
end
