placeSearch = undefined
autocomplete = undefined
$input = undefined
locationField = undefined

componentForm = 
  # street_number: 'short_name'
  # route: 'long_name'
  # locality: 'long_name'
  # administrative_area_level_1: 'short_name'
  country: 'long_name'
  postal_code: 'short_name'

getCurrentLocation = (geolocation)->
  $.get 'http://maps.googleapis.com/maps/api/geocode/json?latlng=' + geolocation.lat + ',' + geolocation.lng + '&sensor=false', (data) ->
    return if !data.results.length > 0
    place = data.results[0]
    i = 0
    while i < place.address_components.length
      address_components = place.address_components[i]
      addressType = address_components.types[0]
      if addressType == 'locality'
        locality = address_components['long_name']
        sessionStorage.setItem 'locality', locality
        locationField.val locality
        break
      i++
    return

geolocate = ->
  locationField = $('#q_location_address_cont')

  if locality = sessionStorage.getItem 'locality'
    locationField.val locality
    return
  if navigator.geolocation
    navigator.geolocation.getCurrentPosition (position) ->
      geolocation = 
        lat: position.coords.latitude
        lng: position.coords.longitude
      getCurrentLocation(geolocation) if locationField.length > 0
      circle = new (google.maps.Circle)(
        center: geolocation
        radius: position.coords.accuracy)
      autocomplete.setBounds circle.getBounds() if autocomplete
      return
  return

fillInAddress = (e) ->
  place = autocomplete.getPlace()
  prefix = $input.data('prefix')
  return if prefix is undefined

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
  geolocate() if window.location.pathname == '/'
  $input = $('.geocomplete')
  return if $input is undefined or $input.length is 0

  input = document.getElementById($input.attr('id'))
  autocomplete = new (google.maps.places.Autocomplete)(input, types: ['geocode'])
  autocomplete.addListener 'place_changed', fillInAddress
  google.maps.event.addDomListener input, 'keydown', (e) ->
    if e.keyCode == 13
      e.preventDefault()
