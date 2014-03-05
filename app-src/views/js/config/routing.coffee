'use strict'

SearchController  = require '../controllers/search.coffee'
QueueController   = require '../controllers/queue.coffee'
ResultsController = require '../controllers/results.coffee'

module.exports = (app) ->
  router  = app.set 'router'

  search  = new SearchController app
  queue   = new QueueController app
  results = new ResultsController app

  search.on 'query', (safeQuery) ->
    router.navigate "search/#{safeQuery}", trigger : yes

  search.on 'reset', ->
    router.navigate '', trigger : yes
