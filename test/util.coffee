util = require '../src/util.coffee'
expect = chai.expect

describe 'util', ->
  it 'should work fine with parseDate method', ->
    expect(util.parseDate('23:33')).to.equal null
    expect(util.parseDate('23:33:33', 'HH:mm')).to.be.ok

    momentDate = util.parseDate '23:33:33', 'HH:mm'
    expect(momentDate.hour()).to.equal 23
    expect(momentDate.minute()).to.equal 33
    expect(momentDate.second()).to.equal 0

    expect(moment.isMoment(util.parseDate('23:33', 'HH:mm'))).to.be.true
    expect(moment.isMoment(util.parseDate(new Date))).to.be.true
    expect(moment.isMoment(util.parseDate(moment()))).to.be.true

  it 'should work fine with parseTimeItem method', ->
    expect(util.parseTimeItem(10)).to.equal '10'
    expect(util.parseTimeItem('10')).to.equal '10'
    expect(util.parseTimeItem('09')).to.equal '09'
    expect(util.parseTimeItem(9)).to.equal '09'