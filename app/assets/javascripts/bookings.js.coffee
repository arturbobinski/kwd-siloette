window.siloette = window.siloette || {}

class @BookingForm
  constructor: (options={}) ->
    @$el = options.$el || $('.booking-form')
    @$startTime = $('#booking_start_time')
    @$endTime = $('#booking_end_time')
    @$totalPrice = $('#booking-total .price')
    @$country = $('#booking_address_attributes_country_id')
    @$stateSelect = $('#booking_address_attributes_state_id')
    @$stateInput = $('#booking_address_attributes_state_name')

    @$startTime.on 'change', @changeStartTime
    @$endTime.on 'change', @changeEndTime
    @$country.on 'change', @changeCountry

  changeStartTime: =>
    selected = @$startTime.find('option:selected')
    @$endTime.html selected.nextAll().clone()

  changeEndTime: =>
    hours = @$endTime.val() - @$startTime.val()
    @$totalPrice.text (window.pricePerHour * hours).toFixed(2)

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

$ ->
  $(document).on 'ready', ->
    window.siloette.bookingForm = new BookingForm() if $('.booking-form').length > 0