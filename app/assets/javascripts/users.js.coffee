$ ->
  $('#user_avatar').change ->
    $this = $(this)
    reader = new FileReader

    reader.onload = ->
      img = new Image
      img.src = reader.result
      $this.parents('.avatar-field-container').find('img').attr 'src', img.src
      return

    reader.readAsDataURL @files[0]
    return

  $('.profile-image-select input[type="checkbox"]').change ->
    $(this).closest('.profile-image-select').toggleClass 'active'
