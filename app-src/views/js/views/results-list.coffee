'use strict'

Tracklist           = require './tracklist.coffee'
TracklistCollection = require '../models/tracklist.coffee'

class ResultsList extends Tracklist
  constructor: ->
    super arguments...

    @scrollTimeout = null

    @collection.on 'reset', =>
      @render()

  el: '.panel-results'
  template: require './templates/results-list.jade'

  events:
    'click .button-add' : 'clickedAdd'

  render: ->
    @$el.html(@template tracklist : @collection)

    @tracklist = @$el.find '.tracklist'
    @tracklist.on 'scroll', => @scroll()
    this

  scroll: ->
    clearTimeout @scrollTimeout if @scrollTimeout

    onTimeout = =>
      @scrollTimeout = null
      console.log 'SCROLL', 
    @scrollTimeout = setTimeout onTimeout, 500
    this

  clickedAdd: (event) ->
    # TODO : Work out what model was clicked etc
    @$(event.currentTarget).prop 'disabled', true

module.exports = ResultsList
