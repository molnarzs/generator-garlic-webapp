var GarlicWebappGenerator, chalk, path, spawn, util, yeoman,
  __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

util = require('util');

path = require('path');

yeoman = require('yeoman-generator');

chalk = require('chalk');

spawn = require('child_process').spawn;

GarlicWebappGenerator = yeoman.generators.Base.extend({
  init: function() {
    this.pkg = yeoman.file.readJSON(path.join(__dirname, '../package.json'));
    this.config.set({
      appName: this.appname,
      css: ['bootstrap'],
      scaffolds: ['']
    });
    console.log(this.yeoman);
    return console.log(chalk.magenta('You\'re using the GarlicTech webapp generator.'));
  },
  saveConfig: function() {
    return this.config.save();
  },
  scaffoldFolders: function() {
    this.mkdir("./frontend");
    this.mkdir("./frontend/modules");
    this.mkdir("./frontend/resources");
    this.mkdir("./frontend/styles");
    this.mkdir("./backend/config");
    this.mkdir("./backend/config/env");
    this.mkdir("./backend/modules");
    this.mkdir("./features");
    this.mkdir("./features/step_definitions");
    this.mkdir("./features/support");
    return this.mkdir("./logs");
  },
  copyMainFiles: function() {
    this.config = this.config.getAll();
    return this.directory("./default", "./");
  },
  runNpm: function() {
    var done, seleniumLogdir, seleniumLogdirLink;
    if (__indexOf.call(this.options, 'skip-install') < 0) {
      done = this.async();
      console.log("\nRunning NPM Install. Bower is next.\n");
      seleniumLogdir = path.join(this.destinationRoot(), 'node_modules', 'selenium-server', 'logs');
      seleniumLogdirLink = path.join(this.destinationRoot(), 'logs', 'selenium');
      return this.npmInstall("", (function(_this) {
        return function() {
          spawn('ln', ['-sf', seleniumLogdir, seleniumLogdirLink], {
            stdio: 'inherit'
          });
          return done();
        };
      })(this));
    }
  },
  runBower: function() {
    var done;
    if (__indexOf.call(this.options, 'skip-install') < 0) {
      done = this.async();
      console.log("\nRunning Bower:\n");
      return this.bowerInstall("", function() {
        console.log("\nAll set! Type: gulp serve\n");
        return done();
      });
    }
  }
});

module.exports = GarlicWebappGenerator;
