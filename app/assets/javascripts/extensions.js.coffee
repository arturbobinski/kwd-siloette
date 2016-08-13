window.siloette = window.siloette || {}

class @ExtensionForm
  constructor: (options={}) ->
    @$el = options.$el || $('.booking-extension-form')
    @hours = options.hours || 0
    @pricerPerHour = options.pricePerHour
    @$hoursInput = $('#booking_extension_hours')
    @$extraPrice = $('#extra-price .price')
    @$hoursInput.on 'change', @changeHours

  changeHours: =>
    @$extraPrice.text @pricerPerHour * parseInt(@$hoursInput.val())


