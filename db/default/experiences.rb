['Modeling', 'Stripping', 'Dancing', 'Presenting', 'Waitressing', 'Singing'].each do |name|
  Experience.find_or_create_by(name: name)
end