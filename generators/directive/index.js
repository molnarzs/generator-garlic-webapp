var GarlicWebappDirectiveGenerator, _, chalk, fs, generatorLib, gulpFilter, gulpRename, path, spawn, util, yeoman;

util = require('util');

path = require('path');

yeoman = require('yeoman-generator');

chalk = require('chalk');

spawn = require('child_process').spawn;

_ = require('lodash');

fs = require('fs');

gulpFilter = require('gulp-filter');

gulpRename = require('gulp-rename');

generatorLib = require('../lib');

GarlicWebappDirectiveGenerator = yeoman.generators.Base.extend({
  initializing: {
    init: function() {
      if (!this.options.view) {
        console.log(chalk.magenta('You\'re using the GarlicTech webapp directive generator.'));
      }
      return this.folder = "./src";
    }
  },
  prompting: function() {
    var cb, done;
    if (this.options.view) {
      return;
    }
    done = this.async();
    cb = (function(_this) {
      return function(answers) {
        _this.answers = answers;
        return done();
      };
    })(this);
    return this.prompt([
      {
        type: 'input',
        name: 'name',
        message: 'Module name (like foo-component):',
        required: true
      }
    ], cb.bind(this));
  },
  writing: {
    createConfig: function() {
      return generatorLib.createDirectiveConfig.bind(this)();
    },
    mainFiles: function() {
      var root;
      root = "" + this.answers.name;
      if (this.options.view) {
        root = "views/" + this.answers.name + "-view";
      }
      return this.fs.copyTpl(this.templatePath('default/**/*'), this.destinationPath(this.folder + "/" + root), {
        c: this.conf
      });
    },
    "directive-modules.coffee": function() {
      var content, dest;
      if (this.options.view) {
        return;
      }
      dest = this.destinationPath(this.folder + "/directive-modules.coffee");
      content = "Module = angular.module \"" + this.conf.angularModuleName + ".Directives\", [";
      _.forEach(this.moduleNames, function(moduleName) {
        return content += "\n  require './" + moduleName + "'";
      });
      content += "\n]\n\nmodule.exports = Module.name";
      return this.fs.write(dest, content);
    },
    "test-view-components.jade": function() {
      var content, dest;
      if (this.options.view) {
        return;
      }
      dest = this.destinationPath(this.folder + "/views/test-view/test-view-components.jade");
      content = "";
      _.forEach(this.moduleNames, (function(_this) {
        return function(moduleName) {
          return content += _this.conf.appNameFQ + "-" + _this.answers.name + "\n";
        };
      })(this));
      return this.fs.write(dest, content);
    },
    saveConfig: function() {
      return this.config.set('angularModules', this.conf.angularModules);
    }
  }
});

module.exports = GarlicWebappDirectiveGenerator;
