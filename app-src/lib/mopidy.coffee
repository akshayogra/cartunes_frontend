'use strict'

exports.search = (m, query, done) ->
  promise = m.library.search any : query

  gotResults = (results) ->
    tracks    = []
    instances = []

    for searchResults in results
      tracks.push searchResults.tracks...

    done null, tracks

  gotError = (err) -> done err

  promise.then gotResults, gotError
