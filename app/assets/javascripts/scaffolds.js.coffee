initFormValidation = ($el) ->
  $parsleyForm = $el.find('[data-parsley-validate]')
  $parsleyForm.parsley() if $parsleyForm.length > 0

initializePlugins = ->
  $('.modal').on 'loaded.bs.modal', ->
    initFormValidation $(this)

  today = new Date()
  legalAge = 21
  legalYear = today.getFullYear() - legalAge

  $('.datepicker').datepicker
    changeMonth: true
    changeYear: true
    yearRange: '1970:' + legalYear
    dateFormat: 'yy-mm-dd'
    defaultDate: legalYear + '-1-1'

  $('.select2').select2()

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

$(document).ready initializePlugins
$(document).on 'turbolinks:load', ->
  initializePlugins()
  initFormValidation $(document)