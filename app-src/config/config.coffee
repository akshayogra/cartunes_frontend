'use strict'

config = require '../../config.json'

module.exports = (app) ->
  app.set 'redis host', config.redisHost
  app.set 'redis port', config.redisPort
  app.set 'redis auth', config.redisAuth
