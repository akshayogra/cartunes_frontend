// Generated by CoffeeScript 1.9.3
'use strict';
var express;

express = require('express');

module.exports = function(app, done) {
  var afterModels, afterMopidy;
  done || (done = function(err) {});
  app || (app = express());
  require('./config/config.js')(app);
  require('./config/main.js')(app);
  require('./config/database.js')(app);
  afterModels = function(err) {
    if (err) {
      return done(err);
    }
    return require('./config/mopidy.js')(app, afterMopidy);
  };
  afterMopidy = function() {
    require('./config/shoe.js')(app);
    require('./config/routing.js')(app);
    require('./config/after.js')(app);
    return done(null, app);
  };
  return afterModels();
};
