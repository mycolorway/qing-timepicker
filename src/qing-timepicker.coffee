Input = require './input.coffee'
Popover = require './popover.coffee'

class QingTimepicker extends QingModule

  @opts:
    el: null
    format: 'HH:mm:ss'
    renderer: null

  @count: 0

  constructor: (opts) ->
    super

    @el = $ @opts.el
    unless @el.length > 0
      throw new Error 'QingTimepicker: option el is required'

    @opts = $.extend {}, QingTimepicker.opts, @opts
    @id = ++ QingTimepicker.count
    @_render()
    @_initChildComponents()
    @_bind()

    if $.isFunction @opts.renderer
      @opts.renderer.call @, @wrapper, @

    @setTime moment(@el.val(), @opts.format, true)

  _render: ->
    @wrapper = $ '<div class="qing-timepicker"></div>'
      .data 'qingTimepicker', @
      .insertBefore @el
      .append @el
    @clearButton = $ '<a href="javascript:;" class="clear-button">x</a>'
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
      wrapper: @wrapper
    , componentOpts

  _bind: ->
    $(document).on "click.qing-timepicker-#{@id}", (e) =>
      return if $.contains @wrapper[0], e.target
      @popover.setActive false
      @input.setActive false
      null

    @input.on 'click', =>
      if @popover.active
        @popover.setActive false
        @input.setActive false
      else
        @popover.setTime @time?.clone() || moment()
        @popover.setActive true
        @input.setActive true

    @clearButton.on 'click', =>
      if @popover.active
        @popover.setActive false
        @input.setActive false

      @clear()
      @trigger 'clear'

    @popover
      .on 'show', (e) =>
        @popover.setPosition
          top: @input.el.outerHeight() + 2
      .on 'hover', (e, type) =>
        @input.highlight type if @time
      .on 'mouseout', =>
        @input.removeHighlight()
      .on 'select', (e, time) =>
        @setTime time
        @clearButton.addClass 'active'

  setTime: (time) ->
    parsed =
      if moment.isMoment(time) then time else moment(time, @opts.format, true)
    if parsed.isValid() && !parsed.isSame(@time)
      formattedTime = parsed.format(@opts.format)
      @time = parsed.clone()

      @input.setValue @time
      @el.val formattedTime
      @trigger 'change', [formattedTime]

  getTime: ->
    @time?.format @opts.format

  clear: ->
    @time = null
    @input.setValue @time
    @el.val ''
    @clearButton.removeClass 'active'

  destroy: ->
    @el.insertAfter @wrapper
      .show()
      .removeData 'qingTimepicker'
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
