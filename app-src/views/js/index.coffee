'use strict'

# Setup backbone
bb   = require 'backbone'
bb.$ = require 'jquery'

page = require 'page'
app  = new (require './lib/app.coffee')
window.app = app

Dplyr = require './views/dplyr.coffee'

app.set 'dplyr', new Dplyr
