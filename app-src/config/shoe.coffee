dnode = require 'dnode'

module.exports = (app) ->
  shoe = app.set 'shoe'
  api  = require('../lib/dnode.js')(app)

  dnodeClients = []
  app.set 'dnode clients', dnodeClients

  shoe.on 'connection', (stream) ->
    d = dnode api

    dnodeClients.push(d)
    d.on 'end', ->
      index = dnodeClients.indexOf d
      dnodeClients.splice index, 1

    d.pipe(stream).pipe(d)
