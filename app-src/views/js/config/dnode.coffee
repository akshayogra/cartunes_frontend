'use strict'

shoe   = require 'shoe'
dnode  = require 'dnode'
inject = require 'reconnect-core'
reconnect = inject shoe

module.exports = (app, done) ->
  reconnect (stream) ->
    d = dnode()
    d.on 'remote', (remote) ->
      app.set 'dnode', remote
    d.once 'remote', done
    d.pipe(stream).pipe(d)
  .connect '/shoe'
