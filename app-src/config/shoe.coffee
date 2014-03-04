dnode = require 'dnode'

module.exports = (app) ->
  shoe = app.set 'shoe'
  api  = require('../lib/dnode.js')(app)

  shoe.on 'connection', (stream) ->
    d = dnode api
    d.pipe(stream).pipe(d)
