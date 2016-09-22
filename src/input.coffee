util = require './util.coffee'

class Input extends QingModule

  @opts:
    wrapper: null
    showHour: true
    showMinute: true
    showSecond: true
    placeholder: ''

  _setOptions: (opts) ->
    super
    $.extend @opts, Input.opts, opts

  _init: ->
    @wrapper = $ @opts.wrapper
    @active = false

    @_render()
    @_renderItem('hour') if @opts.showHour
    @_renderItem('minute') if @opts.showMinute
    @_renderItem('second') if @opts.showSecond
    @_bind()

  _render: ->
    @el = $ '<div class="input" tabindex="0" role="input"></div>'

    @el.append "<span class='placeholder'>#{@opts.placeholder}</span>"
    @timeWrapper = $ '<ul class="time-wrapper"></ul>'
      .appendTo @el

    @el.appendTo @wrapper

  _renderItem: (type) ->
    $ '<li><span class="value"></span></li>'
      .attr 'data-type', type
      .appendTo @timeWrapper
    $('<li class="divider">:</li>').appendTo @timeWrapper

  _bind: ->
    @el.on 'click', (e) =>
      @trigger if @active then 'blur' else 'focus'

    @el.on 'keydown', (e) =>
      if ~[util.ENTER_KEY, util.ARROW_UP_KEY, util.ARROW_DOWN_KEY].indexOf(e.keyCode)
        @trigger 'focus' unless @active

      if util.ESCAPE_KEY == e.keyCode && @active
        @trigger 'blur'

  setValue: (time) ->
    if time
      ['hour', 'minute', 'second'].forEach (type) => @_setItemValue(type, time)
      @el.addClass 'selected'
    else
      @el.removeClass 'selected'

  _setItemValue: (type, time) ->
    @timeWrapper.find("[data-type='#{type}'] .value")
      .text util.parseTimeItem(time[type]())

  setActive: (active) ->
    @active = active
    @el.toggleClass 'active', active
    @el.blur() unless active
    @active

  highlight: (type) ->
    @removeHighlight()
    @timeWrapper.find("[data-type='#{type}'] .value").addClass 'highlight'

  removeHighlight: ->
    @timeWrapper.find('.value.highlight').removeClass 'highlight'

  destroy: ->
    @el.remove()

module.exports = Input
