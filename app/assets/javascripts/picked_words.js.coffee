# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$('html').addClass 'js'

pwIndex =
  config:
    transF:  { effect: 'slideToggle', speed: 300 }
    transFW: { effect: 'fadeToggle', speed: 300 }
    spin:    { radius: 5, width: 3, left: 450, top: 'auto' }
    latency: 800

  picks:
    container:   $('section#picks')
    list:        $('section#picks div#list')
    errorMesg:   $('section#picks div#mesgs p#error')
    loadingMesg: $('section#picks div#mesgs p#loading')
    nopicksMesg: $('section#picks div#mesgs p#nopicks')
    updating:    null

    updatePick: (args) ->
      cfg = pwIndex.config
      p   = pwIndex.picks

      pick = $(@)
      url  = pick.find('a[data-action=show]').attr 'href'

      p.updating = $.ajax
        type: 'PUT'
        url: url
        data: args.data
        dataType: 'json'
        cache: false
        timeout: 8000
        beforeSend: ->
          $('#messages').contents().remove()
        complete: ->
          p.updating = null
          args.onComplete?.call pick
        success: ->
          data = arguments[0]
          args.onSuccess?.call pick, data
        error: ->
          args.onError?.call pick

    toggleFav: (e) ->
      e.preventDefault()

      f = pwIndex.filters
      p = pwIndex.picks

      badge = $(@)
      pick  = badge.closest 'article'
      faved = if badge.hasClass('badge-fav') then 0 else 1

      p.updatePick.call pick,
        data: { picked_word: {fav: faved} }
        onSuccess: (data) ->
          pick = $(@)

          badge = pick.find('span[data-info=fav]')
          badge.toggleClass('badge-fav badge-unfav')

          time = pick.find('time')
          lastEdited = new Date(time.data('last_edited')).toDateString()
          today = new Date(Date.now()).toDateString()

          unless lastEdited is today
            time.fadeOut 'fast', ->
              $(@).text('today').fadeIn()
              $(@).data('last_edited', data.updated_at)

          favs = f.langFilter.find('span[data-info=fav]').hasClass('badge-fav')
          if favs and not badge.hasClass('badge-fav')
            pick.fadeOut ->
              $(@).remove()
              p.nopicksMesg.show() if p.list.children('article').length is 0

  filters:
    container:    $('section#filters')
    wrapper:      $('section#filters div.pw-filters_wrapper')
    langFilter:   $('section#filters div#lang_filter')
    letterFilter: $('section#filters div#letter_filter')
    tfWrapper:    $('section#filters div#lang_filter span.pw-tf_wrapper')
    filtering:    null

    applyFilter: (args) ->
      cfg = pwIndex.config
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
          $('section#messages').contents().remove()
          p.errorMesg.hide()
          p.nopicksMesg.delay(cfg.latency).fadeOut('fast')
          p.loadingMesg.delay(cfg.latency).fadeIn('fast').spin(cfg.spin)
          p.list.children().fadeOut(cfg.latency)
        complete: ->
          p.loadingMesg.spin(false).stop(true).hide()
          f.filtering = null
        success: ->
          args.onSuccess?.call link
        error: ->
          status = arguments[1]
          p.errorMesg.show() unless status is 'abort'

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
        if link.data('filter') is '@' then tf.restore() else tf.colapse()

    toggleFav: ->
      f  = pwIndex.filters
      lf = f.letterFilter

      link  = $(@)
      badge = link.children('span.badge')

      lf.find('li.active').removeClass 'active'
      badge.toggleClass 'badge-fav'

      # if we are served the faved picks
      # we must remove 'favs=1' chunk from 'fav' filter url
      # and append it to letter filters url
      faved  = badge.hasClass 'badge-fav'
      chunks = unfav: {ptrn: /favs=1\&/, str: ''}, fav: {ptrn: /\?/, str: '?favs=1\&'}

      # fchunks: chunks used to update fav link url
      # lchunks: chunks used to update letters link url
      [fchunks, lchunks] = if faved then [chunks.unfav, chunks.fav] else [chunks.fav, chunks.unfav]

      link.attr 'href', link.attr('href').replace(fchunks.ptrn, fchunks.str)
      lf.find('a').each ->
        $(@).attr 'href', $(@).attr('href').replace(lchunks.ptrn, lchunks.str)

    hiliteLetter: ->
      link = $(@)
      li   = link.parent()

      li.siblings('.active').removeClass 'active'
      li.addClass 'active' unless link.data('filter') is '@'

    stick: (e, dir) ->
      f   = pwIndex.filters
      c   = $('section#content')

      if dir is 'down'
        f.container.css height: f.wrapper.outerHeight()
        f.wrapper.addClass('pw-sticky').stop().css(top: 0).animate({top: 40, width: c.outerWidth()})
      else
        f.container.css height: 'auto'
        f.wrapper.removeClass('pw-sticky').stop().animate({top: 'auto', width: c.outerWidth()}, 'fast')

  translationForm:
    container: $('section#translation_form')

    colapse: ->
      tf = pwIndex.translationForm
      tf.toggle() if tf.container.is(':visible')

    restore: ->
      tf = pwIndex.translationForm
      tf.toggle() if tf.container.is(':hidden')

    toggle: ->
      cfg = pwIndex.config
      tf  = pwIndex.translationForm
      f   = pwIndex.filters

      f.tfWrapper[cfg.transFW.effect] cfg.transFW.speed
      tf.container[cfg.transF.effect] cfg.transF.speed, ->
        $.scrollTo '0px', cfg.transF.speed + 100
        tf.container.find('div#fields input#name').focus()

  init: (options) ->
    $.extend @.config, options

    tf = @.translationForm
    f  = @.filters
    p  = @.picks

    tf.container.on 'click', 'a.close', tf.toggle

    f.langFilter.on   'click', 'span.pw-tf_wrapper', tf.toggle
    f.langFilter.on   'click', 'a[data-filter=fav]', f.filterByFav
    f.letterFilter.on 'click', 'a', f.filterByLetter
    f.container.waypoint handler: f.stick

    p.list.on 'click', 'article span[data-info=fav]', p.toggleFav

pwIndex.init()
