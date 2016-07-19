class AvatarUploader < ImageUploader

  version :mini do
    process :resize_to_fill => [80, 80]
  end

  version :medium do
    process :resize_to_fill => [250, 250]
  end
end
