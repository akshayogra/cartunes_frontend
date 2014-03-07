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
    @top     = null

    @setupListeners()
    @checkPlaying()

  setupListeners: ->
    @app.on 'queue:add', (track, addr) => @queueAdd track, addr
    @app.on 'queue:downvote', (track, addr) => @queueDownvote track, addr

    @mopidy.on 'event:trackPlaybackStarted', (track) => @trackChange track.tl_track.track

    @mopidy.on 'event:playbackStateChanged', (state) =>
      unless 'playing' == state.new_state
        @playing = no
      else
        @playing = yes

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

      if app.set('vote limit') >= track.votes
        @db.removeTrack track, trackRemoved

        for client in @clients
          client.queue?.trackRemoved? track
      else
        @triggerTrackChanged track

    trackRemoved = (err) =>
      throw err if err



    @db.downvoteTrack track, addr, downvoted

    this

  triggerTrackChanged: (track) ->
    for client in @clients
      client.queue?.trackChanged? track

    # Get top of queue
    @queueNextTrack()
    @checkPlaying()

    this

  queueUpdate: (oldTrack) ->
    gotQueue = (err, tracks) =>
      throw err if err

      track = tracks[tracks.length - 1]

      if oldTrack
        for client in @clients
          client.queue?.trackRemoved? oldTrack

      for client in @clients
        client.queue?.trackChanged? track

      # Set next track
      @top = tracks[0].uri
      helpers.setNextTrack @mopidy, tracks[0], nextTrackSet

    nextTrackSet = (err) =>
      throw err if err

    @db.getQueue @app.set('queue max'), gotQueue

    this

  queueRefresh: ->
    gotQueue = (err, tracks) =>
      return if err

      for client in @clients
        client.queue?.refresh? tracks

    @db.getQueue @app.set('queue max'), gotQueue

    this

  queueNextTrack: ->
    gotQueue = (err, tracks) =>
      return if err
      return if @top == tracks[0].uri

      @top = tracks[0].uri
      helpers.setNextTrack @mopidy, tracks[0], setNextTrack

    setNextTrack = (err) =>
      throw err if err

    @db.getQueue @app.set('queue max'), gotQueue

    this

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
    console.error 'SETPLAYING', track
    this

module.exports = MopidyController
