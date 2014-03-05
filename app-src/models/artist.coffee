'use strict'

Mopidy = require './mopidy.js'

class Artist extends Mopidy
  constructor: (data) ->
    super data

    @data.name = data.name

module.exports = Artist
