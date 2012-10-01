# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

(->
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

      stick: (e, dir) ->
        f = pwIndex.filters

        if dir == 'down'
          f.container.css height: f.wrapper.outerHeight()
          f.wrapper.addClass('pw-sticky').stop().animate(top: 40)
        else
          f.container.css height: 'auto'
          f.wrapper.removeClass 'pw-sticky'

    translationForm:
      container: $('#translation_form')
      toggle: ->
        tf      = pwIndex.translationForm
        f       = pwIndex.filters
        tf_cfg  = pwIndex.config.transF
        tfw_cfg = pwIndex.config.transFW

        tf.container[tf_cfg.effect](tf_cfg.speed)
        f.tfWrapper[tfw_cfg.effect](tfw_cfg.speed)

    init: (options) ->
      $.extend @.config, options

      tf = @.translationForm
      f  = @.filters

      f.tfWrapper.css   'display', 'none'
      tf.container.on   'click', '.close', tf.toggle
      f.langFilter.on   'click', '.pw-tf_wrapper', tf.toggle
      f.container.waypoint handler: f.stick

  pwIndex.init()
)()
