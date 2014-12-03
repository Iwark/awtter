$ ()->

  # placeholderの有効化
  $('input, textarea').placeholder()

  $('.group h4').on 'click', ()->
    $(this).parent().parent().find('.group-accounts').toggle()

  # ボタングループへの処理
  $('.btn-toggle input[checked]').parent().addClass('active btn-primary')
  $('.btn-toggle .btn').on 'click', (e)->

    if $(this).parent().find('.btn-primary').size() > 0
      $(this).parent().find('.btn-primary').toggleClass('btn-primary')

    $(this).toggleClass('btn-primary')