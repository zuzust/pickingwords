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

  filters:
    container:      $('#filters')
    wrapper:        $('#filters .pw-filters_wrapper')
    langFilter:     $('#lang_filter')
    letterFilter:   $('#letter_filter')
    tfWrapper:      $('#filters .pw-tf_wrapper')

    applyFilter: (handlers) ->
      link = $(@)

      $.ajax
        type: 'GET'
        url: link.attr 'href'
        dataType: 'script'
        success: (response) ->
          handlers?.onSuccess.call(link)

    filterByFav: (e) ->
      e.preventDefault()

      f = pwIndex.filters
      f.applyFilter.call @, {onSuccess: f.toggleFav}

    filterByLetter: (e) ->
      e.preventDefault()

      f  = pwIndex.filters
      tf = pwIndex.translationForm

      f.applyFilter.call @, onSuccess: ->
        link = $(@)

        f.hiliteLetter.call link
        if link.text() is '@' then tf.restore() else tf.colapse()

    toggleFav: ->
      f = pwIndex.filters

      link = $(@)
      span = link.children('span.badge')

      # if the 'fav' link url contained 'favs=1'
      # we are served the faved picks
      # and we must remove that chunk from current url
      url    = link.attr 'href'
      faved  = url.search(/favs=1/) >= 0
      chunks = if faved then [/favs=1\&/, ''] else [/\?/, '?favs=1\&']

      link.attr 'href', url.replace(chunks[0], chunks[1])
      span.toggleClass 'badge-fav'

      f.favLetters faved

    favLetters: (faved) ->
      lf = pwIndex.filters.letterFilter
      chunk = if faved then [/\?/, '?favs=1\&'] else [/favs=1\&/, '']

      lf.find('a').each ->
        $(@).attr 'href', $(@).attr('href').replace(chunk[0], chunk[1])

      lf.find('li.active').removeClass 'active'

    hiliteLetter: ->
      link = $(@)
      li   = link.parent()

      li.siblings('.active').removeClass 'active'
      li.addClass 'active' unless link.text() is '@'

    stick: (e, dir) ->
      f = pwIndex.filters

      if dir is 'down'
        f.container.css height: f.wrapper.outerHeight()
        f.wrapper.addClass('pw-sticky').stop().animate top: 40
      else
        f.container.css height: 'auto'
        f.wrapper.removeClass 'pw-sticky'

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

      tf.container[tf_cfg.effect](tf_cfg.speed)
      f.tfWrapper[tfw_cfg.effect](tfw_cfg.speed)
      $.scrollTo '0px', tf_cfg.speed

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
