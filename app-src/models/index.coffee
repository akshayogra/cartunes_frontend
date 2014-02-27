'use strict'

mpath = require 'path'
exec  = require('child_process').exec

module.exports = (app, done) ->
  exec(
    "find '#{mpath.resolve __dirname}' -name '*.js'"
  , (err, out) ->
    return done err if err

    out = out.split "\n"
    out.pop()

    for model, i in out
      continue unless -1 == model.indexOf 'index.js'
      require(model)(app)
      console.error "Loaded model: #{model}"

    done()
  )
