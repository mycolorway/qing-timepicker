SelectView = require './select-view.coffee'

class Popover extends QingModule
  @opts:
    wrapper: null
    showHour: true
    showMinute: true
    showSecond: true

  _setOptions: (opts) ->
    super
    $.extend @opts, Popover.opts, opts

  _init: ->
    @wrapper = $ @opts.wrapper
    @active = false
    @selectors = []
    @time = moment()

    @_render()
    @_initChildComponents()
    @_bind()

  _render: ->
    @el = $ '<div class="qing-timepicker-popover"></div>'
      .appendTo @wrapper

  _initChildComponents: ->
    if @opts.showHour then @_initSelectView('hour')
    if @opts.showMinute then @_initSelectView('minute')
    if @opts.showSecond then @_initSelectView('second')

  _initSelectView: (type) ->
    @selectors.push new SelectView
      wrapper: @el
      type: type

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
    @active = active
    @el.toggleClass 'active', active
    if @active
      @trigger 'show'
      @selectors.forEach (selector) -> selector.scrollToSelected()
    else
      @trigger 'hide'
    @active

  setPosition: (position) ->
    @el.css
      top: position.top
      left: position.left || 0

  destroy: ->
    @el.remove()

module.exports = Popover