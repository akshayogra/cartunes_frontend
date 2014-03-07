'use strict'

ListController = require './list.coffee'

class QueueController extends ListController
  constructor: (app) ->
    super app, 'queue'

    @view = @dplyr.queue

    @router.on 'route:queue', =>
      @view.focus()

    @app.on 'queue:trackChanged', (track) =>
      @trackChanged track

    @refresh ->

    @init()

  refresh: (done) ->
    gotQueue = (err, tracks) =>
      return done err if err

      @view.list.collection.reset tracks
      done()

    @dnode().queue.get gotQueue

    this

  trackChanged: (track) ->
    @view.list.collection.add track, merge : true
    this

module.exports = QueueController
