'use strict'

Emitter = require('events').EventEmitter
helpers = require '../lib/mopidy.js'

class MopidyController extends Emitter
  constructor: (app) ->
    @app     = app
    @mopidy  = app.set 'mopidy'
    @clients = app.set 'dnode clients'

    @setupListeners()

  setupListeners: ->
    @app.on 'queue:add', (track, addr) => @queueAdd track, addr

    this

  queueAdd: (track, addr) ->
    console.error 'QUEUE:ADD', track, addr

    this

module.exports = MopidyController
