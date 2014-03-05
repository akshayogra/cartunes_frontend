'use strict'

Emitter = require('events').EventEmitter

class AppController extends Emitter
  constructor: (app, name) ->
    @app    = app
    @name   = name
    @router = app.set 'router'
    @dplyr  = app.set 'dplyr'

  dnode: -> @app.set 'dnode'

module.exports = AppController
