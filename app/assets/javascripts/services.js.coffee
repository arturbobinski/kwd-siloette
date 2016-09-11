window.siloette = window.siloette || {}

class @ServiceForm
  constructor: (options={}) ->
    @$el = options.$el || $('.service-form')
    @categories = options.categories || []

    @id = @$el.data('id')
    @$categorySelect = $('#service_category_id')
    @$priceInput = $('#service_price')
    @$serviceImages = $('#service-images')
    @authenticityToken = $('[name="authenticity_token"]').val()
    @setPrimayPhoto()

    @$categorySelect.on 'change', @showCategoryHint
    @$priceInput.on 'change keyup', @showPriceHint
    @$serviceImages.on 'cocoon:before-insert', @beforeInsertImage
    @$serviceImages.on 'cocoon:after-insert', @afterInsertImage
    @$serviceImages.on 'cocoon:before-remove', @beforeRemoveImage
    @$serviceImages.on 'cocoon:after-remove', @afterRemoveImage

    @showCategoryHint()
    @showPriceHint()
    for item in @$el.find('#service-images .nested-fields:visible')
      @.fileUpload $(item) if item

  showCategoryHint: =>
    val = parseInt @$categorySelect.val()
    result = $.grep @categories, (e) ->
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

    if !isNaN(price) && isFinite(val)
      $('.earn').text((price * 95 / 100).toFixed(2))
      $('#price-hint').show()
    else
      $('#price-hint').hide()

  setPrimayPhoto: ->
    @$el.find('.upload-image-placeholder').removeClass 'primary'
    images = @$el.find('.upload-image-placeholder img:visible')
    i = 0
    while i < images.length
      $img = $(images[i])
      unless $img.attr('src') == ''
        $img.closest('.upload-image-placeholder').addClass 'primary'
        break
      i++

  beforeInsertImage: (e, item) =>

  afterInsertImage: (e, item) =>
    item.find('input').click()
    @fileUpload item

  beforeRemoveImage: (e, item) =>
    item.find('input[type="hidden"]').val true
    $next = item.next()
    if $next.length && $next.is('input[type="hidden"]')
      id = $next.val()
      $.ajax
        url: '/service_images/' + id
        data: { authenticity_token: @authenticityToken }
        method: 'DELETE'
        success: ->
          $next.remove()
          return
    return

  afterRemoveImage: (e, item) =>
    $el = $(e.target)
    if $el.find('.upload-image-placeholder:visible').length < 4
      $el.find('.add_fields').click()
    $('#service_images_count').val($el.find('img:visible').length)
    @setPrimayPhoto()

  fileUpload: ($el) ->
    _this = @
    serviceId = @id
    $msg = $el.find('.fileupload-text')
    token = @authenticityToken

    $el.find('.fileupload').fileupload
      url: $el.data('url')
      type: $el.data('method')
      dataType: 'json'
      autoUpload: true
      acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i
      formData: { authenticity_token: token, service_id: serviceId }
      maxFileSize: 30 * 1000 * 1000 # 30Mb
      dropZone: $el
      processalways: (e, data) ->
        index = data.index
        file = data.files[index]
        if file.error
          $msg.text(file.error).css(color: 'red').fadeIn()
      done: (e, data) =>
        result = data.result
        id = result.id
        $el.data('url', '/service_images/' + id)
        $el.data('method', 'PUT')
        $el.find('img').attr 'src', result.url
        $msg.fadeOut()
        $next = $el.next()
        unless $next && $next.is('input')
          $idInput = $el.find('input[type="hidden"]').clone()
          $idInput.attr('name', $idInput.attr('name').replace('_destroy', 'id'))
          $idInput.attr('id', $idInput.attr('id').replace('_destroy', 'id'))
          $idInput.val(id).insertAfter($el)
        $('#service_images_count').val(parseInt($('#service_images_count').val()) + 1)
        _this.setPrimayPhoto()
      progress: (e, data) ->
        progress = parseInt(data.loaded / data.total * 100, 10)
        $msg.text(progress + '%').css(color: 'white').fadeIn()
      error: (jqXHR, textStatus, errorThrown) ->
        if jqXHR.responseText && (msg = JSON.parse(jqXHR.responseText).error)
          $msg.text(msg).css(color: 'white').css(color: 'red').fadeIn()
      fail: (e, data) ->
        if data.errorThrown == 'abort'
          $msg.fadeOut()
