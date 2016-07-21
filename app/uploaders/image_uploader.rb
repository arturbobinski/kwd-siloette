# encoding: utf-8

class ImageUploader < BaseUploader
  include CarrierWave::RMagick

  process :store_dimensions

  def scale(width, height)
    resize_to_fill(width, height)
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  private

  def store_dimensions
    if file && model && model.respond_to?(:width)
      img = ::Magick::Image::read(file.file).first
      model.width = img.columns
      model.height = img.rows
    end
  end
end
