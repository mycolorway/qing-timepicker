Input = require './input.coffee'
Popover = require './popover.coffee'
util = require './util.coffee'

class QingTimepicker extends QingModule
  @name: 'QingTimepicker'

  @opts:
    el: null
    format: 'HH:mm:ss'
    renderer: null
    appendTo: null

  @count: 0

  _setOptions: (opts) ->
    super
    $.extend @opts, QingTimepicker.opts, opts

  _init: ->
    @el = $ @opts.el
    unless @el.length > 0
      throw new Error 'QingTimepicker: option el is required'

    return initialized if (initialized = @el.data('qingTimepicker'))

    @id = ++ QingTimepicker.count
    @_render()
    @_initChildComponents()
    @_bind()

    if $.isFunction @opts.renderer
      @opts.renderer.call @, @wrapper, @

    @setTime @el.val()

  _render: ->
    @wrapper = $ '<div class="qing-timepicker"></div>'
      .data 'qingTimepicker', @
      .insertBefore @el
      .append @el
    @clearButton = $ '<a href="javascript:;" class="clear-button">&times;</a>'
      .attr 'tabindex', -1
      .appendTo @wrapper
    @el.hide()
      .data 'qingTimepicker', @

  _initChildComponents: ->
    componentOpts = extractChildComponentOpts @opts.format

    @input = new Input $.extend
      wrapper: @wrapper
      placeholder: @opts.placeholder || @el.attr('placeholder') || ''
    , componentOpts

    @popover = new Popover $.extend
      wrapper: @opts.appendTo && $(@opts.appendTo) || @wrapper
    , componentOpts

  _bind: ->
    $(document).on "click.qing-timepicker-#{@id}", (e) =>
      return if $.contains(@wrapper[0], e.target)
      return if $.contains(@popover.el[0], e.target)
      @popover.setActive false
      @input.setActive false
      null

    @input
      .on 'focus', =>
        @popover.setTime @time?.clone() || moment()
        @popover.setActive true
        @input.setActive true
      .on 'blur', =>
        @popover.setActive false
        @input.setActive false

    @clearButton.on 'click', =>
      if @popover.active
        @popover.setActive false
        @input.setActive false

      @clear()

    @popover
      .on 'show', =>
        @_updatePopoverPosition()
      .on 'hide', =>
        @input.removeHighlight()
        @input.setActive false
      .on 'hover', (e, type) =>
        @input.highlight type if @time
      .on 'mouseout', =>
        @input.removeHighlight()
      .on 'select', (e, time) =>
        @setTime time

  _updatePopoverPosition: ->
    if @opts.appendTo
      position = @wrapper.position()
      pos =
        top: position.top + @input.el.outerHeight() + 6
        left: position.left
    else
      pos =
        top: @input.el.outerHeight() + 6

    @popover.setPosition pos

  setTime: (time) ->
    parsed = util.parseDate time, @opts.format
    if parsed && !parsed.isSame(@time)
      formattedTime = parsed.format(@opts.format)
      @time = parsed

      @input.setValue @time
      @el.val formattedTime
      @clearButton.addClass 'active'
      @trigger 'change', [formattedTime]

  getTime: ->
    @time?.format @opts.format

  clear: ->
    @time = null
    @input.setValue @time
    @el.val ''
    @trigger 'change', ['']
    @clearButton.removeClass 'active'

  destroy: ->
    @el.insertAfter @wrapper
      .show()
      .removeData 'qingTimepicker'
    @popover.destroy()
    @wrapper.remove()
    $(document).off ".qing-timepicker-#{@id}"

extractChildComponentOpts = (format) ->
  opts = {}
  switch format
    when 'HH:mm:ss'
      opts.showHour = opts.showMinute = opts.showSecond = true
    when 'HH:mm'
      opts.showHour = opts.showMinute = true
      opts.showSecond = false
    when 'mm:ss'
      opts.showHour = false
      opts.showMinute = opts.showSecond = true
  opts

module.exports = QingTimepicker
