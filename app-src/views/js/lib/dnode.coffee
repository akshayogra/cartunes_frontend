'use strict'

module.exports = (app) ->
  return {
    queue          :
      trackChanged : (track) ->
        app.emit 'queue:trackChanged', track

      refresh      : (tracks) ->
        app.emit 'queue:refresh', tracks
  }

