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

$(document).ready initializePlugins
$(document).on 'turbolinks:load', ->
  initializePlugins()
  initFormValidation $(document)