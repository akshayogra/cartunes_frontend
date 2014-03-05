'use strict'

AppController = require './app.coffee'

class QueueController extends AppController
  constructor: (app) ->
    super app, 'queue'

    @queue = @dplyr.queue

    @router.on 'route:queue', =>
      @queue.focus()

module.exports = QueueController
