window.siloette = window.siloette || {}

class @ServiceForm
  constructor: (options={}) ->
    @$el = options.$el || $('.service-form')
    @$categorySelect = $('#service_category_id')
    @$priceInput = $('#service_price')
    @$serviceImages = $('#service-images')

    @$categorySelect.on 'change', @showCategoryHint
    @$priceInput.on 'change', @showPriceHint
    @$serviceImages.on 'cocoon:before-insert', @beforeInsertImage
    @$serviceImages.on 'cocoon:after-insert', @afterInsertImage
    @$serviceImages.on 'cocoon:before-remove', @beforeRemoveImage
    @$serviceImages.on 'cocoon:after-remove', @afterRemoveImage

    @showCategoryHint()
    @showPriceHint()

  showCategoryHint: =>
    val = parseInt @$categorySelect.val()
    result = $.grep window.categories, (e) ->
      return e.id == val

    if result.length > 0
      text = result[0].description
      $('#category-hint span').text(text)
      $('#category-hint').show()
    else
      $('#category-hint').hide()

  showPriceHint: =>
    val = @$priceInput.val()
    price = parseFloat val

    if !isNaN(price) && isFinite(val) && price > 0
      commission = price * (window.commissionFee) / 100
      $('.commission-fee').text(commission)
      $('#price-hint').show()
    else
      $('#price-hint').hide()

  beforeInsertImage: (e, item) =>

  afterInsertImage: (e, item) =>
    item.find('input').click()

  beforeRemoveImage: (e, item) =>

  afterRemoveImage: (e) ->
    $el = $(e.target)
    if $el.find('.upload-image-placeholder:visible').length < 4
      $el.find('.add_fields').click()

$ ->
  $(document).on 'ready', ->
    window.siloette.serviceForm = new ServiceForm() if $('.service-form').length > 0