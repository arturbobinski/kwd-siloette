window.ParsleyConfig =
  excluded: 'input[type=button], input[type=submit], input[type=reset], :hidden, .no-validate'

initFormValidation = ($el) ->
  $parsleyForm = $el.find('[data-parsley-validate]')
  $parsleyForm.parsley() if $parsleyForm.length > 0

initializePlugins = ->
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

  today = new Date()
  today.setHours(0, 0, 0, 0)
  date = $.queryParams().date
  currentDate = if date then new Date(date) else today
  $('.calendar-datepicker').datepicker
    defaultDate: currentDate
    onSelect: (date, obj) ->
      params = $.queryParams()
      params.date = moment(date).format('YYYY-MM-DD')
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

  $('[data-score]').raty
    readOnly: true
    score: ->
      return $(this).attr('data-score')

  $('[name*="time_zone"]').set_timezone()

$(document).ready initializePlugins
$(document).on 'turbolinks:load', ->
  initializePlugins()
  initFormValidation $(document)