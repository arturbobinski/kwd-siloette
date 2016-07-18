# encoding: utf-8

class ImageUploader < BaseUploader
  include CarrierWave::RMagick

  def scale(width, height)
    resize_to_fill(width, height)
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
