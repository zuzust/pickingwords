# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$('html').addClass 'js'

pwIndex =
  config:
    transF:
      effect: 'slideToggle'
      speed: 300
    transFW:
      effect: 'fadeToggle'
      speed: 300

  picks:
    container:   $('#picks')
    list:        $('#picks #list')
    errorMesg:   $('#picks #mesgs #error')
    loadingMesg: $('#picks #mesgs #loading')
    nopicksMesg: $('#picks #mesgs #nopicks')

  filters:
    container:      $('#filters')
    wrapper:        $('#filters .pw-filters_wrapper')
    langFilter:     $('#lang_filter')
    letterFilter:   $('#letter_filter')
    tfWrapper:      $('#filters .pw-tf_wrapper')
    filtering:      null

    applyFilter: (handlers) ->
      f = pwIndex.filters
      p = pwIndex.picks

      link = $(@)

      f.filtering.abort() if f.filtering?
      f.filtering = $.ajax
        type: 'GET'
        url: link.attr 'href'
        dataType: 'script'
        cache: false
        timeout: 8000
        beforeSend: ->
          $('#messages').contents().remove()
          p.list.children().fadeOut 'fast'
          p.errorMesg.hide()
          p.nopicksMesg.delay(1000).fadeOut 'fast'
          p.loadingMesg.delay(1000).fadeIn('fast').spin {radius: 5, width: 3, top: 40}
        complete: ->
          p.loadingMesg.spin(false).stop(true).hide()
          f.filtering = null
        success: ->
          handlers?.onSuccess.call link
        error: (response) ->
          p.errorMesg.show() unless response.statusText is 'abort'

    filterByFav: (e) ->
      e.preventDefault()

      f = pwIndex.filters
      f.applyFilter.call @, onSuccess: f.toggleFav

    filterByLetter: (e) ->
      e.preventDefault()

      f  = pwIndex.filters
      tf = pwIndex.translationForm

      f.applyFilter.call @, onSuccess: ->
        link = $(@)

        f.hiliteLetter.call link
        if link.text() is '@' then tf.restore() else tf.colapse()

    toggleFav: ->
      f  = pwIndex.filters
      lf = f.letterFilter

      link = $(@)
      span = link.children('span.badge')

      lf.find('li.active').removeClass 'active'
      span.toggleClass 'badge-fav'

      # if the 'fav' link url contained 'favs=1'
      # we are served the faved picks
      # and we must remove that chunk from current urls
      url    = link.attr 'href'
      faved  = url.search(/favs=1/) >= 0
      chunks = unfav: {ptrn: /favs=1\&/, str: ''}, fav: {ptrn: /\?/, str: '?favs=1\&'}

      # fchunks: chunks used to update fav link url
      # lchunks: chunks used to update letters link url
      [fchunks, lchunks] = if faved then [chunks.unfav, chunks.fav] else [chunks.fav, chunks.unfav]

      link.attr 'href', url.replace(fchunks.ptrn, fchunks.str)
      lf.find('a').each ->
        $(@).attr 'href', $(@).attr('href').replace(lchunks.ptrn, lchunks.str)

    hiliteLetter: ->
      link = $(@)
      li   = link.parent()

      li.siblings('.active').removeClass 'active'
      li.addClass 'active' unless link.text() is '@'

    stick: (e, dir) ->
      f = pwIndex.filters
      c = $('#content')

      if dir is 'down'
        f.container.css height: f.wrapper.outerHeight()
        f.wrapper.addClass('pw-sticky').stop().animate {width: c.outerWidth()}, 'fast'
      else
        f.container.css height: 'auto'
        f.wrapper.removeClass('pw-sticky').stop().animate {width: c.outerWidth()}, 'fast'

  translationForm:
    container: $('#translation_form')

    colapse: ->
      tf = pwIndex.translationForm
      tf.toggle() if tf.container.is(':visible')

    restore: ->
      tf = pwIndex.translationForm
      tf.toggle() if tf.container.is(':hidden')

    toggle: ->
      tf      = pwIndex.translationForm
      f       = pwIndex.filters
      tf_cfg  = pwIndex.config.transF
      tfw_cfg = pwIndex.config.transFW

      f.tfWrapper[tfw_cfg.effect] tfw_cfg.speed
      tf.container[tf_cfg.effect] tf_cfg.speed, ->
        $.scrollTo '0px', tf_cfg.speed + 100

  init: (options) ->
    $.extend @.config, options

    tf = @.translationForm
    f  = @.filters

    tf.container.on   'click', '.close', tf.toggle
    f.langFilter.on   'click', '.pw-tf_wrapper', tf.toggle
    f.langFilter.on   'click', 'a:contains("fav")', f.filterByFav
    f.letterFilter.on 'click', 'a', f.filterByLetter
    f.container.waypoint handler: f.stick

pwIndex.init()
