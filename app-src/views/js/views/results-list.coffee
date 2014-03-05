'use strict'

Tracklist           = require './tracklist.coffee'
TracklistCollection = require '../models/tracklist.coffee'

class ResultsList extends Tracklist
  constructor: ->
    super arguments...

    @scrollTimeout = null
    @tracklist     = null
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

    @trackHeight = @tracklist.find('li').eq(0).outerHeight()
    @tracklist.on 'scroll', => @scroll()
    @scroll()

    this

  clickedAdd: (event) ->
    button = @$(event.currentTarget)
    track  = button.parent()
    index  = @tracklist.index track

    button.prop 'disabled', true

    @trigger 'click:add', index

    this

module.exports = ResultsList
