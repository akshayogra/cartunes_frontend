'use strict'

bb = require 'backbone'
require 'backbone.epoxy'

class Track extends bb.Model
  cleanup: ->
    @off()

module.exports = Track
