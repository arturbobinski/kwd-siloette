['Private house', 'Private apartment', 'Yacht', 'Restaurant', 'Nightclub', 'Public area', 'Office'].each do |name|
  VenueType.find_or_create_by(name: name)
end