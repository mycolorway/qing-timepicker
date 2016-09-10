Input = require '../src/input.coffee'
util = require '../src/util.coffee'
expect = chai.expect

describe 'Input', ->
  $wrapper = null
  input = null

  before ->
    $wrapper = $('<div class="input-wrapper"></div>').appendTo 'body'

  after ->
    $wrapper.remove()
    $wrapper = null

  beforeEach ->
    input = new Input
      wrapper: $wrapper

  afterEach ->
    $wrapper.empty()
    input = null

  it 'should inherit from QingModule', ->
    expect(input).to.be.instanceof QingModule
    expect(input).to.be.instanceof Input

  it 'should append input\'s el to the wrapper', ->
    expect($.contains($wrapper[0], input.el[0])).to.be.true

  it 'should render related items', ->
    $wrapper.empty()
    input = new Input
      wrapper: $wrapper
      showSecond: false

    itemTypes = input.el.find('.time-wrapper [data-type]').map (_, el) ->
      $(el).data('type')
    .get()
    expect(itemTypes).to.include 'hour'
    expect(itemTypes).to.include 'minute'
    expect(itemTypes).to.not.include 'second'

  it 'should trigger click event', ->
    spy = sinon.spy()
    input.on 'click', spy

    input.el.trigger 'click'
    expect(spy.called).to.be.true

  it 'should work with setValue method', ->
    time = moment()
    input.setValue time
    itemValue = input.timeWrapper.find('[data-type="hour"] .value').text()

    expect(input.el.hasClass('selected')).to.be.true
    expect(itemValue).to.equal util.parseTimeItem(time.hour())

    input.setValue null
    expect(input.el.hasClass('selected')).to.be.not.true

  it 'should work with setActive method', ->
    input.setActive true
    expect(input.el.hasClass('active')).to.be.true

    input.setActive false
    expect(input.el.hasClass('active')).to.be.false

  it 'should highlight the item\'s value with the given type', ->
    $item = input.timeWrapper.find('[data-type="hour"] .value')
    input.highlight 'hour'
    expect($item.hasClass('highlight')).to.be.true

    input.removeHighlight()
    $item = input.timeWrapper.find('[data-type="hour"] .value')
    expect($item.hasClass('highlight')).to.be.false