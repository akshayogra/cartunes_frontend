'use strict'

bb = require 'backbone'

TracklistCollection = require '../models/tracklist.coffee'

class Tracklist extends bb.View
  constructor: ->
    super arguments...

    unless @collection
      @collection = new TracklistCollection

module.exports = Tracklist
