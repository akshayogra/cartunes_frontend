'use strict'

bb = require 'backbone'

TracklistCollection = require '../models/tracklist.coffee'

class Tracklist extends bb.View
  constructor: ->
    super arguments...

    @tracklist    = null
    @coversLoaded = null

    unless @collection
      @collection = new TracklistCollection

  render: ->
    @$el.html(@template tracklist : @collection)

    @tracklist = @$el.find '.tracklist'
    @tracks    = @tracklist.find 'li'

    @tracks.each (i, track) =>
      model = @collection.at i
      model.$el = @$ track

    @trackHeight = @tracks.eq(0).outerHeight()
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

  setTrackCover: (track) ->
    return unless track.cover
    track.$el.find('.track-cover').attr 'src', track.cover
    this

module.exports = Tracklist
