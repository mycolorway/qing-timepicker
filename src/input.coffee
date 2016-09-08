class Input extends QingModule

  @opts:
    wrapper: null
    showHour: true
    showMinute: true
    showSecond: true
    placeholder: ''

  constructor: (opts) ->
    super
    @opts = $.extend {}, Input.opts, @opts

    @wrapper = $ @opts.wrapper
    @active = false

    @_render()
    @_renderItem('hour') if @opts.showHour
    @_renderItem('minute') if @opts.showMinute
    @_renderItem('second') if @opts.showSecond
    @_bind()

  _render: ->
    @el = $ '<div class="input"></div>'

    @el.append "<div class='placeholder'>#{@opts.placeholder}</div>"
    @itemWrapper = $ '<ul class="item-wrapper"></ul>'
      .appendTo @el

    @el.appendTo @wrapper

  _renderItem: (type) ->
    $ '<li class="item"><span class="value"></span></li>'
      .attr 'data-type', type
      .appendTo @itemWrapper

  _bind: ->
    @el.on 'click', (e) =>
      @trigger 'click'

  setValue: (time) ->
    if time
      ['hour', 'minute', 'second'].forEach (type) => @_setItemValue(type, time)
      @el.addClass 'selected'
    else
      @el.removeClass 'selected'

  _setItemValue: (type, time) ->
    @itemWrapper.find(".item[data-type='#{type}'] .value")
      .text @_parseItemValue(time[type]())

  setActive: (active) ->
    @active = active
    @el.toggleClass 'active', active
    @active

  highlight: (type) ->
    @removeHighlight()
    @itemWrapper.find(".item[data-type='#{type}'] .value").addClass 'highlight'

  removeHighlight: ->
    @itemWrapper.find('.value.highlight').removeClass 'highlight'

  _parseItemValue: (value) ->
    if value < 10 then "0#{value}" else value.toString()

  destroy: ->
    @el.remove()

module.exports = Input
