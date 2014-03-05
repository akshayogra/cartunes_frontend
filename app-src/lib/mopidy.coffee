'use strict'

Track = require '../models/track.js'

exports.search = (m, query, done) ->
  promise = m.library.search any : query

  gotResults = (results) ->
    tracks    = []
    instances = []

    for searchResults in results
      tracks.push searchResults.tracks...

    for track in tracks
      instances.push new Track track

    done null, instances

  gotError = (err) -> done err

  promise.then gotResults, gotError
