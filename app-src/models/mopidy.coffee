'use strict'

class Mopidy
  constructor: (data) ->
    @data = data

  toJSON: -> @data

module.exports = Mopidy
