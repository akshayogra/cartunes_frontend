'use strict'

async = require 'async'

onCoverQueue = (job, done) ->
  timeout = setTimeout(
    -> done()
    1500
  )

  gotCover = (err, cover) ->
    return done err if err
    clearTimeout timeout
    done null, cover
  job.track.getCover gotCover

module.exports = (app) ->
  app.set 'cover queue', async.queue onCoverQueue, 10
