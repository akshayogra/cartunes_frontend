'use strict'

HomeController   = require '../controllers/home.js'
MopidyController = require '../controllers/mopidy.js'

module.exports = (app) ->
  mopidy = new MopidyController app
  home   = new HomeController app
  app.set 'mopidy controller', mopidy

  app.get '/', home.route 'index'
