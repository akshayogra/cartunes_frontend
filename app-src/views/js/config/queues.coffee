'use strict'

async = require 'async'

onCoverQueue = (job, done) ->
  gotCover = (err, cover) ->
    return done err if err
    done null, cover
  job.track.getCover gotCover

module.exports = (app) ->
  app.set 'cover queue', async.queue onCoverQueue, 5
