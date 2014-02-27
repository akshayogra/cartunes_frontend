'use strict'

AppController = require './app.js'

class HomeController extends AppController
  constructor: (app) ->
    super app, 'home'

  #
  # The home page route
  #
  # @param http.IncomingMessage req
  # @param http.OutoingMessage  res
  # @param Function             next
  #
  index: (req, res, next) ->
    res.render 'home/index'

module.exports = HomeController
