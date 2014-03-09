'use strict';
var redis;

redis = require('redis');

module.exports = function(app) {
  return app.set('redis', redis.createClient(app.set('redis port'), app.set('redis host')));
};
