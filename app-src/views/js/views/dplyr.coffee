'use strict'

bb = require 'backbone'
require 'backbone.epoxy'

SearchBar = require './search-bar.coffee'
Results   = require './results.coffee'
Queue     = require './queue.coffee'

class Dplyr extends bb.View
  constructor: ->
    super arguments...

    @searchBar = new SearchBar
    @results   = new Results
    @queue     = new Queue

module.exports = Dplyr
