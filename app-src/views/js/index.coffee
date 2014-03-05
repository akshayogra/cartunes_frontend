'use strict'

# Setup backbone
bb   = require 'backbone'
bb.$ = require 'jquery'

# Setup page and app
page   = require 'page'
Dplyr  = require './views/dplyr.coffee'
Router = require './lib/router.coffee'
app    = new (require './lib/app.coffee')

bb.app = app

# TODO : Remove
window.dplyr = app

page.once 'ready', ->
  require('./config/dnode.coffee')(app, gotStream)

gotStream = ->
  # Setup other config
  require('./config/lastfm.coffee')(app)

  app.set 'dplyr', new Dplyr
  app.set 'router', new Router

  require('./config/routing.coffee')(app)

  bb.history.start()
