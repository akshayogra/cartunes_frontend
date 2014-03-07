'use strict'

bb = require 'backbone'

class CurrentBar extends bb.View
  constructor: ->
    super arguments...

  el: '.controls-wrap'

  events:
    'click .button-up'   : 'voteClicked'
    'click .button-down' : 'downvoteClicked'

  render: (track) ->
    @model = track

    this

  updateProgress: (percent) ->
    this

  voteClicked: ->
    @trigger 'click:vote'
    this

  downvoteClicked: ->
    @trigger 'click:downvote'
    this

module.exports = CurrentBar
