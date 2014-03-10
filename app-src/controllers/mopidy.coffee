'use strict'

bb      = require 'backbone'
Emitter = require('events').EventEmitter
helpers = require '../lib/mopidy.js'

class Track extends bb.Model
  idAttribute: 'uri'

class Queue extends bb.Collection
  model: Track

class MopidyController extends Emitter
  constructor: (app) ->
    @app       = app
    @mopidy    = app.set 'mopidy'
    @clients   = app.set 'dnode clients'
    @db        = app.set 'db'
    @queue     = new Queue
    @current   = null

    @setupListeners()
    @checkPlaying()

  setupListeners: ->
    @app.on 'queue:add', (track, addr) => @queueAdd track, addr
    @app.on 'queue:downvote', (track, addr) => @queueDownvote track, addr

    @app.on 'current:vote', (clientId)     => @votePlaying clientId, 1
    @app.on 'current:downvote', (clientId) => @votePlaying clientId, -1

    @mopidy.on 'event:trackPlaybackStarted', (track) => @trackChange track.tl_track.track

    @mopidy.on 'event:playbackStateChanged', (s) =>
      state = null
      if 'playing' == s.new_state
        state = 'playing'
      else
        state = 'paused'

      @stateChanged state

    @mopidy.on 'event:seeked', (position) =>
      for client in @clients
        client.state?.change? 'playing', position

    @queue.on 'add change', (track) =>
      track = track.toJSON()
      for client in @clients
        client.queue?.trackChanged? track

    @queue.on 'remove', (track) =>
      track = track.toJSON()
      for client in @clients
        client.queue?.trackRemoved? track

    this

  checkPlaying: ->
    gotState = (state) =>
      return if state == 'playing'
      @db.getQueue @app.set('queue max'), gotQueue

    gotQueue = (err, tracks) =>
      throw err if err
      return unless 0 < tracks.length

      @queue.set tracks

      track = helpers.cleanTrack tracks[0]

      helpers.setNextTrack @mopidy, tracks[0], trackSet

    trackSet = (err) =>
      throw err if err

      @mopidy.playback.play(null)
        .then playing, (err) -> throw err

    playing = ->

    @mopidy.playback.getState()
      .then gotState, (err) -> throw err

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
      else
        @triggerTrackChanged track

    trackRemoved = (err) =>
      throw err if err
      @queueUpdate()

    @db.downvoteTrack track, addr, downvoted

    this

  triggerTrackChanged: ->
    @queueUpdate()
    @checkPlaying()

    this

  queueUpdate: ->
    gotQueue = (err, tracks) =>
      throw err if err

      @queue.set tracks

      if 0 == @queue.length
        @current = null

        for client in @clients
          client.current?.set? null

        return @mopidy.tracklist.clear()

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

  trackChange: (track) ->
    gotTracks = (err, tracks) =>
      throw err if err
      return unless tracks && tracks[0]

      track = tracks[0]

      @db.getVotes [track], gotVotes

    gotVotes = (err) =>
      throw err if err

      # Save current vote state
      @current    =
        votes     : track.votes
        votesHash : track.votesHash

      @db.resetTrack track, trackReset

    trackReset = (err) =>
      throw err if err

      @current.updated = track.updated

      @queueUpdate()
      @setPlaying track

    @db.getTracks [track.uri], gotTracks

    this

  setPlaying: (track) ->
    track.votes     = @current.votes
    track.votesHash = @current.votesHash

    for client in @clients
      client.current?.set? track

    this

  votePlaying: (clientId, amount) ->
    return this unless @current

    s = {}

    @current.votesHash[clientId] = +amount
    votes = 0
    for client, value of @current.votesHash
      votes += +value
    @current.votes = votes

    gotCurrentTrack = (track) =>
      return unless track

      s.track = track

      if app.set('vote limit') >= votes
        @db.removeTrack track, trackRemoved
      else
        @db.setPooledVotes track, votes, setVotes

    trackRemoved = (err) =>
      throw err if err

      if 1 == @queue.length
        @queueUpdate()

      @mopidy.playback.next()
        .then onNext, (err) -> throw err
    onNext = ->

    setVotes = (err) =>
      throw err if err

      # Update playing track
      @queueUpdate()
      @setPlaying s.track

    @mopidy.playback.getCurrentTrack()
      .then gotCurrentTrack, (err) -> throw err

    this

  stateChanged: (state) ->
    gotTimePosition = (position) =>
      for client in @clients
        client.state?.change? state, position

    @mopidy.playback.getTimePosition()
      .then gotTimePosition, (err) -> throw err

    this

  getPlaying: (done) ->
    s = {}

    gotCurrentTrack = (track) =>
      return done() unless track

      track.votes     = @current.votes
      track.votesHash = @current.votesHash
      track.updated   = @current.updated

      s.track = track

      @mopidy.playback.getState()
        .then gotState, (err) -> done err

    gotState = (state) =>
      s.state = if 'playing' == state then state else 'paused'

      @mopidy.playback.getTimePosition()
        .then gotPosition, (err) -> done err

    gotPosition = (position) =>
      done null, s.track, s.state, position

    @mopidy.playback.getCurrentTrack()
      .then gotCurrentTrack, (err) -> done err

    this

module.exports = MopidyController
