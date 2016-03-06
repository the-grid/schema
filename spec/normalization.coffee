chai = require 'chai' unless chai
schema = require '../index'

describe 'Block normalization', ->
  it 'should turn old-style image block into the modern one', ->
    originalBlock =
      type: 'image'
      src: 'image.gif'
      width: 100
      height: 50
      metadata:
        author: 'Henri Bergius'
        author_url: 'http://bergie.iki.fi'
    converted = schema.normalizeBlock originalBlock
    chai.expect(converted.cover).to.be.an 'object'
    chai.expect(converted.cover.src).to.be.equal 'image.gif'
    chai.expect(converted.metadata.author).to.be.an 'array'
    chai.expect(converted.metadata.author.length).to.equal 1
    chai.expect(converted.metadata.author[0].url).to.equal 'http://bergie.iki.fi'
  it 'should keep cover src if it exists', ->
    originalBlock =
      type: 'image'
      src: 'image.gif'
      width: 100
      height: 50
      metadata:
        author: 'Henri Bergius'
        author_url: 'http://bergie.iki.fi'
      cover:
        src: 'cover.png'
    converted = schema.normalizeBlock originalBlock
    chai.expect(converted.cover).to.be.an 'object'
    chai.expect(converted.src).to.be.equal originalBlock.src
    chai.expect(converted.cover.src).to.be.equal originalBlock.cover.src
    chai.expect(converted.metadata.author).to.be.an 'array'
    chai.expect(converted.metadata.author.length).to.equal 1
    chai.expect(converted.metadata.author[0].url).to.equal 'http://bergie.iki.fi'

