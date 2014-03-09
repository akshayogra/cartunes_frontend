'use strict';
var HomeController;

HomeController = require('../controllers/home.js');

module.exports = function(app) {
  var home;
  home = new HomeController(app);
  return app.get('/', home.route('index'));
};
