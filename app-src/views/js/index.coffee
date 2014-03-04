'use strict'

# Setup backbone
bb   = require 'backbone'
bb.$ = require 'jquery'

# Setup page and app
page  = require 'page'
Dplyr = require './views/dplyr.coffee'
app   = new (require './lib/app.coffee')

# TODO : Remove
window.app = app

page.once 'ready', ->
  require('./config/dnode.coffee')(app, gotStream)

gotStream = ->
  app.set 'dplyr', new Dplyr
