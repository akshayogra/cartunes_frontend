'use strict'

$               = require 'jquery'
Tracklist       = require './tracklist.coffee'
QueueCollection = require '../models/queue.coffee'

class QueueList extends Tracklist
  constructor: ->
    @collection = new QueueCollection

    super arguments...

    @collection.on 'reset', =>
      @render()

    @collection.on 'add change', (track) =>
      @addTrack track

    @collection.on 'remove', (track) =>
      @removeTrack track

  el: '.panel-queue'
  template: require './templates/queue-list.jade'
  trackTemplate: require './templates/queue-list-track.jade'

  addTrack: (track) ->
    @collection.sort()
    index = @collection.indexOf track

    unless @tracklist
      @render()
      return this

    if track.$el
      $el = track.$el
    else
      html      = @trackTemplate track : track
      $el       = $ html
      track.$el = $el

    $el.remove()
    @tracks = @tracklist.find 'li'

    if 0 == index
      @tracklist.prepend $el
    else
      $prev = @tracks.eq(index - 1)
      $prev.after $el

    @tracks = @tracklist.find 'li'

    this

  removeTrack: (track, opts) ->
    index = opts.index

    @tracks.eq(index).remove()
    @tracks = @tracklist.find 'li'

    this

module.exports = QueueList
