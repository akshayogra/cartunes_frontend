'use strict';
var config;

config = require('../../config.json');

module.exports = function(app) {
  app.set('redis host', config.redisHost);
  app.set('redis port', config.redisPort);
  app.set('redis auth', config.redisAuth);
  app.set('mopidy ws', config.mopidyWebsocket);
  return app.set('javascript extension', config.javascriptExtension);
};
