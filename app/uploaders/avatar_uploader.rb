class AvatarUploader < ImageUploader

  version :mini do
    process :resize_to_fill => [32, 32]
  end

  version :thumb do
    process :resize_to_fill => [250, 250]
  end
end
