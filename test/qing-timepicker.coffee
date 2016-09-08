QingTimepicker = require '../src/qing-timepicker'
expect = chai.expect

describe 'QingTimepicker', ->

  $el = null
  qingTimepicker = null

  before ->
    $el = $('<div class="test-el"></div>').appendTo 'body'

  after ->
    $el.remove()
    $el = null

  beforeEach ->
    qingTimepicker = new QingTimepicker
      el: '.test-el'

  afterEach ->
    qingTimepicker.destroy()
    qingTimepicker = null

  it 'should inherit from QingModule', ->
    expect(qingTimepicker).to.be.instanceof QingModule
    expect(qingTimepicker).to.be.instanceof QingTimepicker

  it 'should throw error when element not found', ->
    spy = sinon.spy QingTimepicker
    try
      new spy
        el: '.not-exists'
    catch e

    expect(spy.calledWithNew()).to.be.true
    expect(spy.threw()).to.be.true
