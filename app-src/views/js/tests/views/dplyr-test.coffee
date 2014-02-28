'use strict'

assert = require 'assert'
bb     = require 'backbone'
Dplyr  = require '../../views/dplyr.coffee'

describe 'Dplyr', ->
  it 'extends backbone.Epoxy.View', ->
    assert.equal 'function', typeof Dplyr::__proto__.getBinding
