initFormValidation = ($el) ->
  $parsleyForm = $el.find('[data-parsley-validate]')
  $parsleyForm.parsley() if $parsleyForm.length > 0

initializePlugins = ->
  $('.modal').on 'loaded.bs.modal', ->
    initFormValidation $(this)

  today = new Date()
  legalAge = 21

  $('.datepicker').datepicker
    changeMonth: true,
    changeYear: true,
    yearRange: '1970:' + (today.getFullYear() - legalAge),
    dateFormat: 'yy-mm-dd',

$(document).ready initializePlugins
$(document).on 'turbolinks:load', ->
  initializePlugins()
  initFormValidation $(document)