var chalk, execute, generators, path, spawn, util;

util = require('util');

path = require('path');

generators = require('yeoman-generator');

chalk = require('chalk');

spawn = require('child_process').spawn;

execute = function(command) {
  var result;
  result = sh.exec(command);
  return console.log(result.stdout);
};

module.exports = generators.Base.extend({
  constructor: function() {
    generators.Base.apply(this, arguments);
    return this.option("name");
  },
  copyFiles: function() {
    return console.log(chalk.magenta('You\'re using the GarlicTech webapp generator for Angular UI element.'));
  },
  saveConfig: function() {
    return this.config.save();
  }
});
