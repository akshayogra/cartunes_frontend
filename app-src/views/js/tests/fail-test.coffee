assert = require 'assert'

describe 'some measure of fail', ->
  it 'should pass', ->
    assert.ok true == true

  it 'should fail', ->
    throw new Error 'fail!'

  it 'should fail really bad', ->
    throw new Error 'fatal fail!'
