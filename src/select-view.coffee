util = require './util.coffee'

class SelectView extends QingModule
  @opts:
    wrapper: null
    type: 'hour'

  constructor: (opts) ->
    super
    $.extend @opts, SelectView.opts, opts

    @wrapper = $ @opts.wrapper
    @type = @opts.type
    @items = @_generateItems()

    @_render()
    @_renderList()
    @_bind()

  _render: ->
    @el = $ '<div class="select-view"></div>'
      .appendTo @wrapper

  _renderList: ->
    @list = $ '<ul></ul>'
    @list.append @items.map (item, index) -> "<li>#{item}</li>"
    @list.appendTo @el

  _bind: ->
    @list
      .on 'mouseover', 'li', (e) =>
        @trigger 'hover', [@type]
        e.stopImmediatePropagation()
      .on 'click', 'li', (e) =>
        value = parseInt $(e.currentTarget).text(), 10
        @select value
        @trigger 'select', [@type, value]
        @scrollToSelected 120

  _generateItems: ->
    length = if @type is 'hour' then 24 else 60
    [0...length].map (item) => util.parseTimeItem(item)

  select: (value) ->
    value = util.parseTimeItem value
    if @selectedValue != value
      @selectedValue = value
      @selectedItem = @list.find('li').get @items.indexOf(value)

      @list.find('li.selected').removeClass 'selected'
      $(@selectedItem).addClass 'selected'

  scrollToSelected: (duration) ->
    @_scrollTo @el[0], @selectedItem.offsetTop, duration if @selectedItem

  _scrollTo: (el, to, duration = 0) ->
    return el.scrollTop = to if duration <= 0

    perTick = (to - el.scrollTop) / duration * 10
    window.requestAnimationFrame =>
      el.scrollTop = el.scrollTop + perTick
      @_scrollTo el, to, duration - 10 unless el.scrollTop == to

module.exports = SelectView