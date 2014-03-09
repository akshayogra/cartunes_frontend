var Mopidy;

Mopidy = require('mopidy');

module.exports = function(app, done) {
  var mopidy;
  mopidy = new Mopidy({
    webSocketUrl: app.set('mopidy ws')
  });
  app.set('mopidy', mopidy);
  return mopidy.once('state:online', done);
};
