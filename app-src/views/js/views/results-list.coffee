'use strict'

Tracklist           = require './tracklist.coffee'
TracklistCollection = require '../models/tracklist.coffee'

class ResultsList extends Tracklist
  constructor: ->
    super arguments...

    @collection.on 'reset', =>
      @render()

  el: '.panel-results'
  template: require './templates/results-list.jade'

  render: ->
    @$el.html(@template tracklist : @collection)
    this

module.exports = ResultsList
