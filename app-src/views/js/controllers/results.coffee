'use strict'

AppController = require './app.coffee'

class ResultsController extends AppController
  constructor: (app) ->
    super app, 'results'

    self = this

    @results = @dplyr.results

    @router.on 'route:queue', =>
      @results.list.collection.reset []

    @router.on 'route:search', (query) =>
      @results.focus()
      @getResults query

    @results.list.on 'scroll', (start, count) =>
      @queueCovers start, count

  gotResults: (data) ->
    @results.list.collection.reset data
    this

  getResults: (query) ->
    # Get search results
    @dnode().db.search query, (err, results) =>
      return @app.emit 'error', err if err
      @gotResults results
    this

  queueCovers: (start, count) ->
    q        = @app.set 'cover queue'
    hasReset = no

    onReset = ->
      hasReset = yes
    @results.list.collection.once 'reset', onReset

    end = start + count

    tracks = @results.list.collection.models.slice(start, end).reverse()
    tracks.forEach (track, i) =>
      index = end - i - 1
      return if @results.list.coversLoaded[index]

      q.unshift track : track, (err, cover) =>
        return if err || hasReset
        @results.list.setTrackCover index, cover
        @results.list.collection.off 'reset', onReset

    this

module.exports = ResultsController
