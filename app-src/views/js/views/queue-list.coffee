'use strict'

Tracklist           = require './tracklist.coffee'
TracklistCollection = require '../models/tracklist.coffee'

class QueueList extends Tracklist
  template: require './templates/queue-list.jade'

module.exports = QueueList
