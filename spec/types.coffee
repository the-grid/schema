chai = require 'chai' unless chai
schema = require '../index'

describe 'Type handling', ->

  describe 'handling block type hierarchy', ->
    it 'should recognize anything as a block', ->
      chai.expect(schema.isSubtypeOf('h1', 'block')).to.equal true
      chai.expect(schema.isSubtypeOf('text', 'block')).to.equal true
      chai.expect(schema.isSubtypeOf('unknown', 'block')).to.equal true
    it 'should recognize any headline level anything as a headline', ->
      chai.expect(schema.isSubtypeOf('h1', 'headline')).to.equal true
      chai.expect(schema.isSubtypeOf('h2', 'headline')).to.equal true
      chai.expect(schema.isSubtypeOf('h6', 'headline')).to.equal true
      chai.expect(schema.isSubtypeOf('headline', 'headline')).to.equal true
    it 'should not recognize non-headlines as a headline', ->
      chai.expect(schema.isSubtypeOf('text', 'headline')).to.equal false
      chai.expect(schema.isSubtypeOf('video', 'headline')).to.equal false
    it 'should recognize any text element as a textual', ->
      chai.expect(schema.isSubtypeOf('h1', 'textual')).to.equal true
      chai.expect(schema.isSubtypeOf('headline', 'textual')).to.equal true
      chai.expect(schema.isSubtypeOf('text', 'textual')).to.equal true
      chai.expect(schema.isSubtypeOf('code', 'textual')).to.equal true
      chai.expect(schema.isSubtypeOf('quote', 'textual')).to.equal true
    it 'should not recognize non-text elements as a textual', ->
      chai.expect(schema.isSubtypeOf('image', 'textual')).to.equal false
      chai.expect(schema.isSubtypeOf('video', 'textual')).to.equal false
    it 'should recognize any media element as media', ->
      chai.expect(schema.isSubtypeOf('image', 'media')).to.equal true
      chai.expect(schema.isSubtypeOf('video', 'media')).to.equal true
      chai.expect(schema.isSubtypeOf('audio', 'media')).to.equal true
      chai.expect(schema.isSubtypeOf('article', 'media')).to.equal true
      chai.expect(schema.isSubtypeOf('location', 'media')).to.equal true
      chai.expect(schema.isSubtypeOf('quote', 'media')).to.equal true
      chai.expect(schema.isSubtypeOf('interactive', 'media')).to.equal true
    it 'should recognize any data element as data', ->
      chai.expect(schema.isSubtypeOf('list', 'data')).to.equal true
      chai.expect(schema.isSubtypeOf('table', 'data')).to.equal true
    it 'should recognize CtA elements as cta', ->
      chai.expect(schema.isSubtypeOf('cta', 'cta')).to.equal true
    it 'should support also block objects', ->
      header =
        type: 'h1'
      chai.expect(schema.isSubtypeOf(header, 'textual')).to.equal true
