class Input extends QingModule

  @opts:
    wrapper: null
    placeholder: ''

  constructor: (opts) ->
    super
    @opts = $.extend {}, Input.opts, @opts

    @wrapper = $ @opts.wrapper
    @active = false
    @_render()
    @_bind()

  _render: ->
    @el = $ '<div class="input">'
    @textField = $ '<input type="text" class="text-field" readonly>'
      .attr 'placeholder', @opts.placeholder
      .appendTo @el
    @el.appendTo @wrapper

  _bind: ->
    @textField.on 'click', (e) =>
      @trigger 'click'

  setValue: (value) ->
    @textField.val value
    value

  getValue: ->
    @textField.val()

  setActive: (active) ->
    @active = active
    @textField.toggleClass 'active', active
    @active

  selectRange: (type) ->
    @textField.focus()

    [selectionStart, selectionEnd] = switch type
      when 'hour' then [0, 2]
      when 'minute' then [3, 5]
      when 'second' then [6, 8]

    @textField[0].setSelectionRange selectionStart, selectionEnd

  destroy: ->
    @el.remove()

module.exports = Input
