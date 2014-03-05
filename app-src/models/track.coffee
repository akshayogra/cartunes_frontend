'use strict'

Mopidy = require './mopidy.js'
Album  = require './album.js'

class Track extends Mopidy
  constructor: (data) ->
    super data

    @data.name     = data.name
    @data.number   = data.track_no
    @data.album    = new Album data.album
    @data.date     = data.date
    @data.duration = data.length

module.exports = Track
