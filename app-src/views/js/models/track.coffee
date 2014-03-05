'use strict'

bb = require 'backbone'
require 'backbone.epoxy'

class Track extends bb.Model
  cleanup: ->
    @off()

  albumCover: (done) ->
    lastfm = bb.app.set 'lastfm'

    lastfm.album.getInfo
      artist : @get('album').artists[0].name
      album  : @get('album').name
    , success : (data) ->
        for image in data.album.image
          return done null, image['#text'] if 'medium' == image.size
        done()
      error   : (code, message) ->
        error = new Error message
        error.code = code
        done error

    this

module.exports = Track
