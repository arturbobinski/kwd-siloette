window.siloette = window.siloette || {}

class @BookingForm
  constructor: (options={}) ->
    @$el = options.$el || $('.booking-form')
    @hours = options.hours || 1
    @pricerPerHour = options.pricePerHour
    @total = @getTotal()
    @availableSlots = window.availableSlots

    @$startTime = $('#booking_start_time')
    @$hours = $('#booking_hours')
    # @$endTime = $('#booking_end_time')
    @$totalPrice = $('#booking-total .price')
    @$pricePerGuest = $('#price-per-guest .price')
    @$country = $('#booking_address_attributes_country_id')
    @$stateSelect = $('#booking_address_attributes_state_id')
    @$stateInput = $('#booking_address_attributes_state_name')
    @$guestsInput = $('#booking_number_of_guests')

    @$startTime.on 'change', @changeStartTime
    @$hours.on 'change', @changeHours
    @$guestsInput.on 'change', @changeGuests
    # @$endTime.on 'change', @changeEndTime
    @$country.on 'change', @changeCountry
    @$el.on 'submit', @submitForm

  getTotal: ->
    @pricerPerHour * @hours

  showTotal: ->
    @total = @getTotal()
    @$totalPrice.text @total.toFixed(2)

  checkAvailable: ->


  changeStartTime: =>
    # selected = @$startTime.find('option:selected')
    # @$endTime.html selected.nextAll().clone()
    @checkAvailable()
    @showTotal()

  changeHours: =>
    @hours = @$hours.val()
    @checkAvailable()
    @showTotal()
    @changeGuests()

  changeEndTime: =>
    @hours = @$endTime.val() - @$startTime.val()
    @showTotal()

  changeGuests: =>
    guests = parseInt @$guestsInput.val()
    @$pricePerGuest.text (@total / guests).toFixed(2)

  changeCountry: =>
    countryId = @$country.val()
    _this = @
    $.get '/api/states', { country_id: countryId }, (data) ->
      if data.length > 0
        selected = parseInt _this.$stateSelect.val()
        _this.$stateSelect.html '<option></option>'
        $.each data, (i, state) ->
          opt = ($ document.createElement('option')).attr('value', state.id).html(state.name)
          opt.prop 'selected', true if selected is state.id
          _this.$stateSelect.append opt

        _this.$stateSelect.prop('disabled', false).attr('required', true)
        _this.$stateSelect.closest('.form-group').removeClass('hidden')
        _this.$stateInput.prop('disabled', true).removeAttr('required')
        _this.$stateInput.closest('.form-group').addClass('hidden')
      else
        _this.$stateInput.prop('disabled', false).attr('required', true)
        _this.$stateInput.closest('.form-group').removeClass('hidden')
        _this.$stateSelect.prop('disabled', true).removeAttr('required')
        _this.$stateSelect.closest('.form-group').addClass('hidden')

  stripeResponseHandler: (status, response) =>
    if response.error
      @$el.find('.payment-errors').text(response.error.message).fadeIn()
      @$el.find('input[type="submit"]').prop('disabled', false)
    else
      token = response.id
      @$el.append($('<input type="hidden" name="stripe_token">').val(token))
      @$el.get(0).submit()

  submitForm: =>
    @$el.find('.payment-errors').fadeOut()
    @$el.find('input[type="submit"]').prop('disabled', true)
    if @$el.find('#number:visible').length > 0
      Stripe.card.createToken(@$el, window.siloette.bookingForm.stripeResponseHandler)
      return false
