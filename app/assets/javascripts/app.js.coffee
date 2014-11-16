$ ()->

  # placeholderの有効化
  $('input, textarea').placeholder()

  $('.group h4').on 'click', ()->
    $(this).parent().parent().find('.group-accounts').toggle()