'use strict';
var AppController, HomeController,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

AppController = require('./app.js');

HomeController = (function(_super) {
  __extends(HomeController, _super);

  function HomeController(app) {
    HomeController.__super__.constructor.call(this, app, 'home');
  }

  HomeController.prototype.index = function(req, res, next) {
    return res.render('home/index');
  };

  return HomeController;

})(AppController);

module.exports = HomeController;
