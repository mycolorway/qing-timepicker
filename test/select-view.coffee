SelectView = require '../src/select-view.coffee'
expect = chai.expect

describe 'SelectView', ->
  $wrapper = null
  selectView = null

  before ->
    $wrapper = $('<div class="select-wrapper"></div>').appendTo 'body'

  after ->
    $wrapper.remove()
    $wrapper = null

  beforeEach ->
    selectView = new SelectView
      wrapper: $wrapper

  afterEach ->
    selectView = null
    $wrapper.empty()

  it 'should inherit from QingModule', ->
    expect(selectView).to.be.instanceof QingModule
    expect(selectView).to.be.instanceof SelectView

  it 'should generate 24 items if type is hour', ->
    expect(selectView.items).to.have.lengthOf 24

  it 'should generate 60 items unless type is hour', ->
    $wrapper.empty()
    selectView = new SelectView
      wrapper: $wrapper
      type: 'minute'
    expect(selectView.items).to.have.lengthOf 60

  it 'should append selectView\'s el to the wrapper', ->
    expect($.contains($wrapper[0], selectView.el[0])).to.be.true

  it 'should append list to the selectView\'s el', ->
    expect(selectView.el.find('ul li')).to.have.lengthOf 24

  it 'should trigger hover event when mouse moved onto the list item', ->
    spy = sinon.spy()
    selectView.on 'hover', spy
    selectView.el.find('ul li').first().trigger 'mouseover'
    expect(spy.called).to.be.true

  it 'should trigger select event when click the list item', ->
    spy = sinon.spy()
    selectView.on 'select', spy
    selectView.el.find('ul li:eq(3)').trigger 'click'
    expect(spy.called).to.be.true
    expect(spy.args[0][1]).to.equal 'hour'
    expect(spy.args[0][2]).to.equal 3

  it 'should call selectView\'s select method when click the list item', ->
    selectView.el.find('ul li:eq(3)').trigger 'click'

    expect(selectView.selectedValue).to.equal '03'
    expect(selectView.selectedItem).to.be.ok
    expect(selectView.el.find('ul li:eq(3)').hasClass('selected')).to.be.true

  it 'should call selectView\'s scrollToSelected method when click the list item', ->
    spy = sinon.spy(selectView, 'scrollToSelected')
    selectView.el.find('ul li:eq(3)').trigger 'click'
    expect(spy.called).to.be.true