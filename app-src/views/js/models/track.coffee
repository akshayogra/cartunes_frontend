'use strict'

bb = require 'backbone'
require 'backbone.epoxy'

class Track extends bb.Model
  @COVER_CACHE = {}

  idAttribute: 'uri'

  cleanup: ->
    @off()

  getCover: (done) ->
    artist = @get('artists')[0]?.name || ''
    album  = @get('album').name
    key    = "#{album}:#{artist}"

    if Track.COVER_CACHE[key]
      return done null, Track.COVER_CACHE[key]

    lastfm = bb.app.set 'lastfm'

    lastfm.album.getInfo
      artist : @get('artists')[0]?.name || ''
      album  : @get('album').name
    , success : (data) ->
        for image in data.album.image
          if 'medium' == image.size
            Track.COVER_CACHE[key] = image['#text']
            return done null, image['#text']
        done()
      error   : (code, message) ->
        error = new Error message
        error.code = code
        done error

    this

module.exports = Track
