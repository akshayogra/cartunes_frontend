'use strict'

class Mopidy
  constructor: (data) ->
    @data = {}
    @id   = @data.id = data.uri

  toJSON: -> @data

module.exports = Mopidy
