'use strict'

AppController = require './app.coffee'

class CurrentController extends AppController
  constructor: (app) ->
    super app, 'current'

    @app.on 'current:set', (track) =>
      console.log 'CURRENT', track

module.exports = CurrentController
