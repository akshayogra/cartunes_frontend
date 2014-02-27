'use strict'

redis = require 'redis'

module.exports = (app) ->
  app.set 'redis', redis.createClient(
    app.set 'redis port'
    app.set 'redis host'
  )
