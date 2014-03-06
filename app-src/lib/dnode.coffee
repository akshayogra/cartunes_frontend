'use strict'

helpers = require './mopidy.js'

module.exports = (app) ->
  clients = app.set 'dnode clients'
  mopidy  = app.set 'mopidy'

  return (remote, dnode) ->
    return {
      db       :
        search : (query, done) ->
          helpers.search mopidy, query, done

      queue    :
        add    : (track) ->
          app.emit 'queue:add', track, dnode.stream.remoteAddress
    }
