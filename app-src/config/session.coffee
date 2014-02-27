'use strict'

express    = require 'express'
RedisStore = require('connect-redis')(express)

module.exports = (app) ->
  app.use express.cookieParser()
  app.use(
    express.session
      store    : new RedisStore(
        host   : app.set 'redis host'
        port   : app.set 'redis port'
        pass   : app.set 'redis auth'
      )
      secret   : app.set 'session secret'
      cookie   :
        domain : ".#{app.set 'hostname'}"
  )
  app.use express.csrf()
