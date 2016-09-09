QingTimepicker = require '../src/qing-timepicker'
expect = chai.expect

describe 'QingTimepicker', ->

  $el = null
  qingTimepicker = null
  input = null
  popover = null

  before ->
    $el = $('<input type="text" class="test-el">').appendTo 'body'

  after ->
    $el.remove()
    $el = null

  beforeEach ->
    qingTimepicker = new QingTimepicker
      el: '.test-el'
    input = qingTimepicker.input
    popover = qingTimepicker.popover

  afterEach ->
    qingTimepicker.destroy()
    qingTimepicker = null
    input = null
    popover = null

  it 'should inherit from QingModule', ->
    expect(qingTimepicker).to.be.instanceof QingModule
    expect(qingTimepicker).to.be.instanceof QingTimepicker

  it 'should return the timepicker instance immediate if initialized', ->
    instanceCount = QingTimepicker.count

    new QingTimepicker
      el: '.test-el'

    expect(QingTimepicker.count).to.equal instanceCount

  it 'should call renderer callback on module initialize', ->
    $anotherEl = $('<input type="text" class="timepicker-el" value="23:33">').appendTo 'body'
    renderer = sinon.spy()

    new QingTimepicker
      el: '.timepicker-el'
      renderer: renderer
    expect(renderer.called).to.be.true

    $anotherEl.remove()

  it 'should update timepicker\'s time with the el\'s value', ->
    $anotherEl = $('<input type="text" class="timepicker-el" value="23:33">').appendTo 'body'
    timepicker = new QingTimepicker
      el: '.timepicker-el'
      format: 'HH:mm'

    expect(timepicker.time).to.be.ok
    expect(moment.isMoment(timepicker.time)).to.be.true
    expect(timepicker.time.hour()).to.equal 23
    expect(timepicker.time.minute()).to.equal 33

    $anotherEl.remove()

  it 'should render the popover and input components', ->
    expect(input).to.be.ok
    expect(popover).to.be.ok

  it 'should toggle popover active status when click the input', ->
    input.trigger 'click'
    expect(popover.active).to.be.true
    input.trigger 'click'
    expect(popover.active).to.be.false

    spy = sinon.spy(popover, 'setTime')
    input.trigger 'click'
    expect(spy.called).to.be.true

  it 'should call the related method when popover events triggered', ->
    spy = sinon.spy(popover, 'setPosition')
    popover.trigger 'show'
    expect(spy.called).to.be.true

    spy = sinon.spy(qingTimepicker, 'setTime')
    popover.trigger 'select', moment()
    expect(spy.called).to.be.true

    spy = sinon.spy(input, 'highlight')
    qingTimepicker.time = null
    popover.trigger 'hover'
    expect(spy.called).to.be.false
    qingTimepicker.time = moment()
    popover.trigger 'hover'
    expect(spy.called).to.be.true

    spy = sinon.spy(input, 'removeHighlight')
    popover.trigger 'mouseout'
    expect(spy.called).to.be.true

  it 'should work fine with setTime method', ->
    qingTimepicker.time = null
    qingTimepicker.setTime ''
    expect(qingTimepicker.time).to.be.not.ok

    spy = sinon.spy()
    qingTimepicker.on 'change', spy
    qingTimepicker.setTime '23:33:33'
    expect(qingTimepicker.time).to.be.ok
    expect(qingTimepicker.time.format(qingTimepicker.opts.format)).to.equal '23:33:33'
    expect(spy.called).to.be.true

    qingTimepicker.time = moment()
    qingTimepicker.setTime qingTimepicker.time
    expect(spy.calledOnce).to.be.true

  it 'should work fine with getTime method', ->
    qingTimepicker.time = time = moment()
    expect(qingTimepicker.getTime()).to.equal time.format(qingTimepicker.opts.format)

  it 'should throw error when element not found', ->
    spy = sinon.spy QingTimepicker
    try
      new spy
        el: '.not-exists'
    catch e

    expect(spy.calledWithNew()).to.be.true
    expect(spy.threw()).to.be.true

require './select-view.coffee'
require './popover.coffee'
require './input.coffee'