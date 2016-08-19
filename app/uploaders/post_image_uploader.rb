class PostImageUploader < ImageUploader

  version :thumb do
    process :resize_to_fill => [360, 200]
  end

  version :short do
    process :resize_to_fill => [320, 300]
  end

  version :long do
    process :resize_to_fill => [320, 370]
  end

  version :large do
    process :resize_to_fill => [640, 670]
  end

  version :huge do
    process :resize_to_fill => [1280, 768]
  end
end
