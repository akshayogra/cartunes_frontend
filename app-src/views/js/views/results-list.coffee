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

  scroll: (immediate = false) ->
    clearTimeout @scrollTimeout if @scrollTimeout

    onTimeout = =>
      @scrollTimeout = null

      height    = @tracklist.height()
      inView    = Math.ceil(height / @trackHeight) + 1

      scrollTop = @tracklist.scrollTop()
      gonePast  = Math.floor scrollTop / @trackHeight

      @trigger 'scroll', gonePast, inView

    if immediate
      onTimeout()
    else
      @scrollTimeout = setTimeout onTimeout, 500
    this

  clickedAdd: (event) ->
    # TODO : Work out what model was clicked etc
    @$(event.currentTarget).prop 'disabled', true
    this

  setTrackCover: (index, cover) ->
    @coversLoaded[index] = true
    return unless cover

    track = @tracklist.find('li').eq(index)
    return unless track
    track.find('.track-cover').attr 'src', cover

    this

module.exports = ResultsList
