'use strict'

helpers = require './mopidy.js'
crypto  = require 'crypto'

module.exports = (app) ->
  clients = []
  mopidy  = app.set 'mopidy'
  db      = app.set 'db'

  app.set 'dnode clients', clients

  return (remote, dnode) ->
    clients.push remote

    dnode.once 'end', ->
      index = clients.indexOf remote
      clients.splice index, 1

    addr = crypto.createHash 'sha1'
    addr.update dnode.stream.remoteAddress
    addr = addr.digest 'hex'

    return {
      db       :
        search : (query, done) ->
          helpers.search mopidy, query, done

      queue    :
        add    : (track) ->
          app.emit 'queue:add', track, addr

        downvote : (track) ->
          app.emit 'queue:downvote', track, addr

        get    : (done) ->
          db.getQueue app.set('queue max'), done

      clients  :
        getId  : (done) ->
          done null, addr
    }
