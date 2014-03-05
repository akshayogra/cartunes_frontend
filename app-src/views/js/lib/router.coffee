'use strict'

bb = require 'backbone'

class DplyrRouter extends bb.Router
  routes:
    ''              : 'queue'
    'search/:query' : 'search'

module.exports = DplyrRouter
