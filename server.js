var app  = require('./app')
var http = require('http')

app(null, function (err, app) {
  if (err) throw err

  var server = http.createServer()
  server.on('request', app)

  server.listen(8080)

  console.error('Listening on http://127.0.0.1:8080')
})
