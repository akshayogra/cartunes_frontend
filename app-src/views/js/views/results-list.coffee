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
    @coversLoaded  = []

    @collection.on 'reset', =>
      @render()

  el: '.panel-results'
  template: require './templates/results-list.jade'

  events:
    'click .button-add' : 'clickedAdd'

  render: ->
    @coversLoaded = []

    @$el.html(@template tracklist : @collection)

    @tracklist = @$el.find '.tracklist'
    @tracks    = @tracklist.find 'li'

    @trackHeight = @tracks.eq(0).outerHeight()
    @tracklist.on 'scroll', => @scroll()
    @scroll()

    this

  clickedAdd: (event) ->
    button = @$(event.currentTarget)
    track  = button.parent()
    index  = @tracks.index track

    button.prop 'disabled', true

    @trigger 'click:add', index

    this

module.exports = ResultsList
