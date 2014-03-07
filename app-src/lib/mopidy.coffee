'use strict'

exports.cleanTrack = (track) ->
  delete track.voted
  delete track.votes
  delete track.votesHash
  delete track.updated

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

exports.onError = (err) ->
  console.error err.stack

exports.clear = (m, done) ->
  onError = (err) -> done err

  gotTracks = (tracks) ->
    return done() unless tracks.length

    ids = for track in tracks then track.tlid
    m.tracklist.remove tlid : ids
      .then onRemove, onError

  onRemove = -> done()

  m.tracklist.slice 1, Infinity
    .then gotTracks, onError

exports.setNextTrack = (m, track, done) ->
  onError = (err) -> done err

  onClear = (err) ->
    return done err if err

    m.tracklist.add [track], 1
      .then onAdd, onError
  onAdd = -> done()

  exports.clear m, onClear
