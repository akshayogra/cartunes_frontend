var app  = require('./app')
var http = require('http')

app(null, function (err, app) {
  if (err) throw err

  var server = http.createServer()
  server.on('request', app)

  server.listen(8080)
})
