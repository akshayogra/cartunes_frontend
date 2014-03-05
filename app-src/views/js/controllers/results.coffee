'use strict'

AppController = require './app.coffee'

class ResultsController extends AppController
  constructor: (app) ->
    super app, 'results'

    @results = @dplyr.results

    @router.on 'route:queue', =>
      @results.list.collection.reset []

    @router.on 'route:search', (query) =>
      @results.focus()
      @getResults query

  gotResults: (data) ->
    @results.list.collection.reset data
    this

  getResults: (query) ->
    # Get search results
    @dnode().db.search query, (err, results) =>
      return @app.emit 'error', err if err
      @gotResults results

    this

module.exports = ResultsController
