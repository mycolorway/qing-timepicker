Popover = require '../src/popover.coffee'
expect = chai.expect

describe 'Popover', ->
  $wrapper = null
  popover = null

  before ->
    $wrapper = $('<div class="popover-wrapper"></div>').appendTo 'body'

  after ->
    $wrapper.remove()
    $wrapper = null

  beforeEach ->
    popover = new Popover
      wrapper: $wrapper

  afterEach ->
    $wrapper.empty()
    popover = null

  it 'should inherit from QingModule', ->
    expect(popover).to.be.instanceof QingModule
    expect(popover).to.be.instanceof Popover

  it 'should append popover\'s el to the wrapper', ->
    expect($.contains($wrapper[0], popover.el[0])).to.be.true

  it 'should render selectViews according to the opts', ->
    $wrapper.empty()
    popover = new Popover
      wrapper: $wrapper
      showSecond: false

    expect(popover.selectors).to.have.lengthOf 2
    expect(popover.el.find('.select-view')).to.not.be.empty

    types = popover.selectors.map (selector) -> selector.type
    expect(types).to.include 'hour'
    expect(types).to.include 'minute'
    expect(types).to.not.include 'second'

  it 'should trigger mouseout event when mouse moved out the popover', ->
    spy = sinon.spy()
    popover.on 'mouseout', spy
    popover.el.trigger 'mouseout'
    expect(spy.called).to.be.true

  it 'should trigger hover event when one of selectors trigger hover', ->
    spy = sinon.spy()
    popover.on 'hover', spy
    popover.selectors[0].trigger 'hover'
    expect(spy.called).to.be.true

  it 'should trigger select event when one of selectors trigger select', ->
    spy = sinon.spy()
    selector = popover.selectors[0]

    popover.on 'select', spy
    selector.trigger 'select', [selector.type, 1]
    expect(spy.called).to.be.true
    expect(moment.isMoment(spy.args[0][1])).to.be.true

  it 'should update popover\'s time when one of selectors trigger select', ->
    spy = sinon.spy(popover.time, 'hour')
    selector = popover.selectors[0]

    selector.trigger 'select', [selector.type, 1]
    expect(spy.called).to.be.true

  it 'should update popover\'s time when setTime method called', ->
    oldTime = popover.time
    popover.setTime()
    expect(oldTime.isSame(popover.time)).to.be.true

    popover.setTime(moment())
    expect(oldTime.isSame(popover.time)).to.be.not.true

  it 'should call selector\'s select method when setTime method called', ->
    selector = popover.selectors[0]
    spy = sinon.spy(selector, 'select')

    popover.setTime(moment())
    expect(spy.called).to.be.true
    expect(spy.args[0][0]).to.equal popover.time[selector.type]()

  it 'should work with setActive method', ->
    showSpy = sinon.spy()
    hideSpy = sinon.spy()

    popover.on 'show', showSpy
    popover.on 'hide', hideSpy

    popover.setActive true
    expect(showSpy.called).to.be.true
    expect(popover.el.hasClass('active')).to.be.true

    popover.setActive false
    expect(hideSpy.called).to.be.true
    expect(popover.el.hasClass('active')).to.be.not.true

  it 'should call selector\'s scrollToSelected method when popover active', ->
    selector = popover.selectors[0]
    spy = sinon.spy(selector, 'scrollToSelected')
    popover.setActive true
    expect(spy.called).to.be.true