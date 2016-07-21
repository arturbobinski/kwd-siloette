placeSearch = undefined
autocomplete = undefined
$input = undefined

componentForm = 
  # street_number: 'short_name'
  # route: 'long_name'
  # locality: 'long_name'
  # administrative_area_level_1: 'short_name'
  country: 'short_name'
  postal_code: 'short_name'

geolocate = ->
  if navigator.geolocation
    navigator.geolocation.getCurrentPosition (position) ->
      geolocation = 
        lat: position.coords.latitude
        lng: position.coords.longitude
      circle = new (google.maps.Circle)(
        center: geolocation
        radius: position.coords.accuracy)
      autocomplete.setBounds circle.getBounds()
      return
  return

fillInAddress = (e) ->
  place = autocomplete.getPlace()
  prefix = $input.data('prefix')

  for component of componentForm
    document.getElementById(prefix + component).value = ''
  
  location = place.geometry.location
  $('#' + prefix + 'lat').val location.lat()
  $('#' + prefix + 'lng').val location.lng()

  i = 0
  while i < place.address_components.length
    addressType = place.address_components[i].types[0]
    if componentForm[addressType]
      val = place.address_components[i][componentForm[addressType]]
      document.getElementById(prefix + addressType).value = val
    i++
  return

window.initAutocomplete = ->
  $input = $('.geocomplete')
  return if $input is undefined or $input.length is 0

  input = document.getElementById($input.attr('id'))
  autocomplete = new (google.maps.places.Autocomplete)(input, types: ['geocode'])
  autocomplete.addListener 'place_changed', fillInAddress
  google.maps.event.addDomListener input, 'keydown', (e) ->
    if e.keyCode == 13
      e.preventDefault()
