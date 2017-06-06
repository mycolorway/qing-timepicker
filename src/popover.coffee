SelectView = require './select-view.coffee'

class Popover extends QingModule
  @opts:
    appendTo: null
    showHour: true
    showMinute: true
    showSecond: true
    hourStep: 1
    minuteStep: 1
    secondStep: 1

  _setOptions: (opts) ->
    super
    $.extend @opts, Popover.opts, opts

  _init: ->
    @active = false
    @selectors = []
    @time = moment()

    @_render()
    @_initChildComponents()
    @_bind()

  _render: ->
    @el = $ '<div class="qing-timepicker-popover"></div>'

  _initChildComponents: ->
    if @opts.showHour then @_initSelectView('hour', @opts.hourStep)
    if @opts.showMinute then @_initSelectView('minute', @opts.minuteStep)
    if @opts.showSecond then @_initSelectView('second', @opts.secondStep)

  _initSelectView: (type, step) ->
    @selectors.push new SelectView
      wrapper: @el
      type: type,
      step: step

  _bind: ->
    @selectors.forEach (selector) =>
      selector
        .on 'hover', (e, type) =>
          @trigger 'hover', [type]
        .on 'select', (e, type, value) =>
          @time[type](value)
          @trigger 'select', @time
          @setActive(false) if type == @selectors[@selectors.length - 1].type

    @el.on 'mouseout', (e) =>
      @trigger 'mouseout'
      e.stopImmediatePropagation()

  setTime: (time) =>
    if time && !(@time && @time.isSame(time))
      @time = time
      @selectors.forEach (selector) =>
        selector.select @time[selector.type]()

  setActive: (active) ->
    return if active == @active

    @active = active
    if @active
      @el.addClass('active').appendTo @opts.appendTo
      @trigger 'show'
      @selectors.forEach (selector) -> selector.scrollToSelected()
    else
      @el.removeClass('active').detach()
      @trigger 'hide'

  setPosition: (position) ->
    @el.css
      top: position.top
      left: position.left || 0

  destroy: ->
    @el.remove()

module.exports = Popover
