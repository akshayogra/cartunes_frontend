'use strict'

HomeController   = require '../controllers/home.js'
MopidyController = require '../controllers/mopidy.js'

module.exports = (app) ->
  mopidy = new MopidyController app
  home   = new HomeController app

  app.get '/', home.route 'index'
