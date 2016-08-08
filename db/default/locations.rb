locations = [
  {
    address: 'Miami, FL, United States',
    country: 'United States',
    lat: 25.7617,
    lng: -80.1918,
    active: true
  },
  {
    address: 'Las Vegas, NV, United States',
    country: 'United States',
    lat: 36.1699,
    lng: -115.14,
    active: true
  }
]

locations.each do |location|
  Location.from_attributes(location)
end