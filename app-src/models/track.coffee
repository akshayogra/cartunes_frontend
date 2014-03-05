'use strict'

Mopidy = require './mopidy.js'
Album  = require './album.js'

class Track extends Mopidy
  constructor: (data) ->
    super data

module.exports = Track
