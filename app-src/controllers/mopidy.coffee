'use strict'

Emitter = require('events').EventEmitter
helpers = require '../lib/mopidy.js'

class MopidyController extends Emitter
  constructor: (app) ->
    @app     = app
    @mopidy  = app.set 'mopidy'
    @clients = app.set 'dnode clients'
    @db      = app.set 'db'

    @setupListeners()

  setupListeners: ->
    @app.on 'queue:add', (track, addr) => @queueAdd track, addr
    @app.on 'queue:downvote', (track, addr) => @queueDownvote track, addr

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

module.exports = MopidyController
