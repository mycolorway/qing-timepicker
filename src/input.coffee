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
      @setActive !@active

    @el.on 'keydown', (e) =>
      if ~[util.ENTER_KEY, util.ARROW_UP_KEY, util.ARROW_DOWN_KEY].indexOf(e.keyCode)
        @setActive true

      if util.ESCAPE_KEY == e.keyCode && @active
        @setActive false

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
    return if active == @active

    @active = active
    if @active
      @el.addClass 'active'
      @trigger 'focus'
    else
      @el.removeClass('active').blur()
      @trigger 'blur'

  highlight: (type) ->
    @removeHighlight()
    @timeWrapper.find("[data-type='#{type}'] .value").addClass 'highlighted'

  removeHighlight: ->
    @timeWrapper.find('.value.highlighted').removeClass 'highlighted'

  destroy: ->
    @el.remove()

module.exports = Input
