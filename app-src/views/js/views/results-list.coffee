'use strict'

Tracklist           = require './tracklist.coffee'
TracklistCollection = require '../models/tracklist.coffee'

class ResultsList extends Tracklist
  constructor: ->
    super arguments...

    @scrollTimeout = null
    @tracklist     = null
    @tracks        = null
    @trackHeight   = null

    @collection.on 'reset', =>
      @render()

  el: '.panel-results'
  template: require './templates/results-list.jade'

  events:
    'click .button-add' : 'clickedAdd'

  clickedAdd: (event) ->
    button = @$(event.currentTarget)
    track  = button.parent().parent()
    index  = @tracks.index track

    button.prop 'disabled', true

    @trigger 'click:add', index

    this

module.exports = ResultsList
