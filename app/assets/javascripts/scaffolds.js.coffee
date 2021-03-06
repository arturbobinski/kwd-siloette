window.ParsleyConfig =
  excluded: 'input[type=button], input[type=submit], input[type=reset], :hidden, .no-validate'

$countryCodeInput = undefined
$phoneNumberInput = undefined

initFormValidation = ($el) ->
  $parsleyForm = $el.find('[data-parsley-validate]')
  $parsleyForm.parsley() if $parsleyForm.length > 0

window.readCookieValue = (cookieName) ->
  if result = new RegExp("(?:^|; )" + encodeURIComponent(cookieName) + "=([^;]*)").exec(document.cookie)
    decodeURIComponent(result[1])
  else
    null

updateTwilioUrl = ->
  window.ParsleyExtend.asyncValidators['twilio'].url = 'https://lookups.twilio.com/v1/PhoneNumbers/' + $countryCodeInput.val() + $phoneNumberInput.val()

initializePlugins = ->
  $phoneNumberInput = $('input[type="tel"]')
  $countryCodeInput = $('select.country-code')

  $('.modal').on 'loaded.bs.modal', ->
    initFormValidation $(this)

  $('.toggel-schedule').change ->
    $this = $(this)
    $row = $this.closest('tr')
    $select = $row.find('select')
    if $this.is(':checked')
      $select.prop('disabled', false).attr('required', true)
    else
      $select.prop('disabled', true).removeAttr('required')

  $('#service_search').find('input, select').change ->
    $(this).closest('form').submit()
    # window.location = '/' + $(this).val()

  today = new Date()
  today.setHours(0, 0, 0, 0)
  params = $.queryParams()
  pDate = params.date
  currentDate = if pDate then new Date(pDate) else today
  $('.calendar-datepicker').datepicker
    defaultDate: currentDate
    onSelect: (date, obj) ->
      params.date = moment(new Date(date)).format('YYYY-MM-DD')
      window.location.search = $.param(params)
      return
    beforeShowDay: (date) ->
      string = date.getDay()
      return [window.closedDays.indexOf(string) < 0 && date >= today]

  legalAge = 21
  legalYear = today.getFullYear() - legalAge
  $('.datepicker').datepicker
    changeMonth: true
    changeYear: true
    yearRange: '1970:' + legalYear
    dateFormat: 'yy-mm-dd'
    defaultDate: legalYear + '-1-1'

  $('.select2').select2
    placehoder: $(this).data('placeholder')

  $priceSlider = $('#price-range')
  if $priceSlider.length > 0
    min = parseInt $('#price_min').val()
    max = parseInt $('#price_max').val()

    $priceSlider.slider
      range: true
      min: 0
      max: 2000
      values: [min, max]
      slide: (event, ui) ->
        $('#price_min').val ui.values[0]
        $('#price_max').val ui.values[1]

   $('.slider-for').slick
    slidesToShow: 1
    slidesToScroll: 1
    fade: true
    asNavFor: '.slider-nav'
  $('.slider-nav').slick
    arrows: false
    slidesToShow: 3
    slidesToScroll: 1
    asNavFor: '.slider-for'
    focusOnSelect: true
    vertical: true

  $('[name*="time_zone"]').set_timezone()
  tz = readCookieValue('time_zone')
  if tz is null or tz is ''
    document.cookie = 'time_zone=' + jstz.determine_timezone().timezone.olson_tz;

  if $('.schedule-start').length > 0
    $fakeSelect = $('<select class="hidden" />').appendTo('body').html $($('.schedule-end')[0]).html()
    $('.schedule-start').change ->
      $this = $(this)
      $parent = $this.closest('tr')
      startTime = $(this).val()
      $endInput = $parent.find('.schedule-end')
      endTime = $endInput.val()
      $tmp = $fakeSelect.find('option[value="' + startTime + '"]')
      $endInput.html($tmp.nextAll().clone()).val(endTime)

  if $phoneNumberInput.length > 0
    window.ParsleyExtend.addAsyncValidator 'twilio', ((xhr) ->
      return xhr.status == 200
    ), false, headers: { 'Authorization': 'Basic ' + btoa(window.twilioUsername + ':' + window.twilioToken) }

    $phoneNumberInput.change ->
      updateTwilioUrl()

    updateTwilioUrl()

$(document).ready initializePlugins
$(document).on 'turbolinks:load', ->
  initializePlugins()
  initFormValidation $(document)