class ServiceImageUploader < ImageUploader

  version :small do
    process :resize_to_fill => [150, 200]
  end

  version :medium do
    process :resize_to_fill => [300, 400]
  end
end
