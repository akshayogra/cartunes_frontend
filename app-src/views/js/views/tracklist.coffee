'use strict'

bb = require 'backbone'

TracklistCollection = require '../models/tracklist.coffee'

class Tracklist extends bb.View
  constructor: ->
    super arguments...

    @tracklist = null

    unless @collection
      @collection = new TracklistCollection

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

  setTrackCover: (index, cover) ->
    @coversLoaded[index] = true
    return unless cover

    track = @tracklist.find('li').eq(index)
    return unless track
    track.find('.track-cover').attr 'src', cover

    this

module.exports = Tracklist
