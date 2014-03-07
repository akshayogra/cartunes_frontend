'use strict'

Emitter = require('events').EventEmitter
helpers = require '../lib/mopidy.js'

class MopidyController extends Emitter
  constructor: (app) ->
    @app     = app
    @mopidy  = app.set 'mopidy'
    @clients = app.set 'dnode clients'
    @db      = app.set 'db'
    @playing = no
    @votes   = 0

    @setupListeners()
    @checkPlaying()

  setupListeners: ->
    @app.on 'queue:add', (track, addr) => @queueAdd track, addr
    @app.on 'queue:downvote', (track, addr) => @queueDownvote track, addr

    @mopidy.on 'event:trackPlaybackStarted', (track) => @trackChange track.tl_track.track

    this

  checkPlaying: ->
    return this if @playing

    gotQueue = (err, tracks) =>
      throw err if err
      return unless 0 < tracks.length

      track = helpers.cleanTrack tracks[0]

      helpers.setNextTrack @mopidy, tracks[0], trackSet

    trackSet = (err) =>
      throw err if err

      @mopidy.playback.play(null)
        .then playing, (err) -> throw err

    playing = =>
      @playing = yes

    @db.getQueue @app.set('queue max'), gotQueue

    this

  queueAdd: (track, addr) ->
    votedTrack = (err) =>
      return if err

      # Attach votes to track
      @db.getVotes [track], gotVotes

    gotVotes = (err) =>
      return if err

      # Tell clients track has changed
      @triggerTrackChanged track

    @db.voteTrack track, addr, votedTrack

    this

  queueDownvote: (track, addr) ->
    downvoted = (err) =>
      return if err

      @db.getVotes [track], gotVotes

    gotVotes = (err) =>
      return if err
      @triggerTrackChanged track

    @db.downvoteTrack track, addr, downvoted

    this

  triggerTrackChanged: (track) ->
    for client in @clients
      client.queue?.trackChanged? track

    @checkPlaying()

  queueUpdate: (oldTrack) ->
    gotQueue = (err, tracks) =>
      throw err if err

      track = tracks[tracks.length - 1]

      if oldTrack
        for client in @clients
          client.queue?.trackRemoved? track

      for client in @clients
        client.queue?.trackChanged? track

    @db.getQueue @app.set('queue max'), gotQueue

    this

  queueRefresh: ->
    gotQueue = (err, tracks) =>
      return if err

      for client in @clients
        client.queue?.refresh? tracks

    @db.getQueue @app.set('queue max'), gotQueue

    this

  queueChanged: ->
    gotQueue = (err, tracks) =>
      return if err

    @db.getQueue @app.set('queue max'), gotQueue

  trackChange: (track) ->
    gotTracks = (err, tracks) =>
      throw err if err
      return unless tracks && tracks[0]

      track = tracks[0]

      @db.resetTrack track, trackReset

    trackReset = (err) =>
      throw err if err
      @queueUpdate track
      @setPlaying track

    @db.getTracks [track.uri], gotTracks

    this

  setPlaying: (track) ->
    this

module.exports = MopidyController
