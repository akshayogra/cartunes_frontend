'use strict'

exports.cleanTrack = (track) ->
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

  s = {}

  gotCurrentTrack = (tlTrack) ->
    if tlTrack
      m.tracklist.index tlTrack
        .then gotIndex, onError
    else
      gotPrevious []

  gotIndex = (index) ->
    s.current = index

    if 0 >= index
      gotPrevious []
    else
      m.tracklist.slice 0, index
        .then gotPrevious, onError

  gotPrevious = (tlTracks) ->
    s.previous = tlTracks

    m.tracklist.slice s.current + 1, Infinity
      .then gotTracks, onError

  gotTracks = (tracks) ->
    tracks or= []
    tracks.push s.previous...

    ids = for track in tracks then track.tlid
    m.tracklist.remove tlid : ids
      .then onRemove, onError

  onRemove = -> done()

  m.playback.getCurrentTlTrack()
    .then gotCurrentTrack, onError

exports.setNextTrack = (m, track, done) ->
  onError = (err) -> done err

  exports.cleanTrack track

  onClear = (err) ->
    return done err if err

    m.tracklist.add [track], null
      .then onAdd, onError
  onAdd = -> done()

  exports.clear m, onClear
