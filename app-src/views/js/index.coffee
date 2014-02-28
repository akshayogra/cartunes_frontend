'use strict'

page = require 'page'
app  = new (require './lib/app.coffee')

Dplyer = require('./views/dplyr.coffee')(app)
