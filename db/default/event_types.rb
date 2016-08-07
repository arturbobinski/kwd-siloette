['Birthday party', 'Sports night', 'Club night', 'Fraternity party', 'Corporate event', 'Music festival'].each do |name|
  EventType.find_or_create_by(name: name)
end