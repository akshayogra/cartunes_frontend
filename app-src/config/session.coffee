'use strict'

express    = require 'express'

module.exports = (app) ->
  app.use express.cookieParser()
