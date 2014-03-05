'use strict'

Mopidy = require './mopidy.js'
Artist = require './artist.js'

class Album extends Mopidy
  constructor: (data) ->
    super data

    @data.name = data.name
    @data.date = data.date

    @data.artists = []

    if data.artists
      for artist in data.artists
        @data.artists.push new Artist artist

module.exports = Album
