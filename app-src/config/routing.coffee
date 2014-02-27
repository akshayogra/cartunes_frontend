'use strict'

HomeController = require '../controllers/home.js'

module.exports = (app) ->
  home = new HomeController app

  app.get '/', home.route 'index'
