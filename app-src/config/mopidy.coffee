Mopidy = require 'mopidy'

module.exports = (app, done) ->
  mopidy = new Mopidy
    webSocketUrl : app.set 'mopidy ws'
  app.set 'mopidy', mopidy

  mopidy.once 'state:online', done
