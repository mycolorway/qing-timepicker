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
    @el.hide()
      .data 'qingTimepicker', @

  _initChildComponents: ->
    @input = new Input
      wrapper: @wrapper
      placeholder: @opts.placeholder || @el.attr('placeholder') || ''

    popoverOpts = $.extend
      wrapper: @wrapper
    , extractPopoverOpts(@opts.format)
    @popover = new Popover popoverOpts

  _bind: ->
    $(document).on "click.qing-timepicker-#{@id}", (e) =>
      return if $.contains @wrapper[0], e.target
      @popover.setActive false

    @input.on 'click', =>
      if @popover.active
        @popover.setActive false
        @input.setActive false
      else
        @popover.setTime @time?.clone() || moment()
        @popover.setActive true
        @input.setActive true

    @popover
      .on 'show', (e) =>
        @popover.setPosition
          top: @input.el.outerHeight() + 2
      .on 'hover', (e, type) =>
        @input.selectRange type if @time
      .on 'select', (e, time) =>
        @setTime time

  setTime: (time) ->
    if moment.isMoment(time) && time.isValid() && !time.isSame(@time)
      formattedTime = time.format(@opts.format)
      @input.setValue formattedTime
      @el.val formattedTime
      @time = time.clone()
      @trigger 'change', [formattedTime]

  getTime: ->
    @time?.format @opts.format

  destroy: ->
    @el.insertAfter @wrapper
      .show()
      .removeData 'qingTimepicker'
    @wrapper.remove()
    $(document).off ".qing-timepicker-#{@id}"

extractPopoverOpts = (format) ->
  opts = {}
  switch format
    when 'HH:mm:ss'
      opts.showHour = opts.showMinute = opts.showSecond = true
    when 'HH:mm'
      opts.showHour = opts.showMinute = true
    when 'mm:ss'
      opts.showMinute = opts.showSecond = true
  opts

module.exports = QingTimepicker
