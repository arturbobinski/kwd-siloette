class ServiceImageUploader < ImageUploader

  version :small do
    process :resize_to_fill => [135, 180]
  end

  version :medium do
    process :resize_to_fill => [210, 280]
  end

  version :large do
    process :resize_to_fill => [420, 560]
  end
end
