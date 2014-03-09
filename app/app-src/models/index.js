'use strict';
var exec, mpath;

mpath = require('path');

exec = require('child_process').exec;

module.exports = function(app, done) {
  return exec("find '" + (mpath.resolve(__dirname)) + "' -name '*.js'", function(err, out) {
    var i, model, _i, _len;
    if (err) {
      return done(err);
    }
    out = out.split("\n");
    out.pop();
    for (i = _i = 0, _len = out.length; _i < _len; i = ++_i) {
      model = out[i];
      if (-1 !== model.indexOf('index.js')) {
        continue;
      }
      require(model)(app);
      console.error("Loaded model: " + model);
    }
    return done();
  });
};
