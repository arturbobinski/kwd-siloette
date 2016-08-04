['Modeling', 'Exotic Dancing', 'Hosting', 'Presenting', 'Serving', 'Singing'].each do |name|
  Experience.find_or_create_by(name: name)
end