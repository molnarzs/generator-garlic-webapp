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
      this.conf = this.config.getAll();
      if (!this.options.page) {
        console.log(chalk.magenta('You\'re using the GarlicTech webapp directive generator.'));
      }
      return this.conf.folder = "./src";
    }
  },
  prompting: function() {
    var cb, done;
    if (this.options.page) {
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
      var directiveNameCC;
      this.conf = _.assign(this.conf, generatorLib.createConfig.bind(this)());
      this.moduleNames = this.options.page ? this.conf.angularModules.pages : this.conf.angularModules.directives;
      directiveNameCC = _.capitalize(_.camelCase(this.answers.name));
      this.conf.moduleName = this.conf.angularModuleName + "." + directiveNameCC;
      this.moduleNames.push(this.answers.name);
      if (this.options.page) {
        this.conf.moduleName = this.conf.angularModuleName + "." + moduleName + ".View";
        this.conf.directiveNameCC = this.conf.directiveNameCC + "View";
        return this.conf.directiveNameKC = this.conf.directiveNameKC + "-view";
      } else {
        this.conf.directiveNameCC = "" + this.conf.appNameFQcC + directiveNameCC;
        return this.conf.directiveNameKC = this.conf.appNameFQ + "-" + this.answers.name;
      }
    },
    mainFiles: function() {
      var root;
      root = "" + this.answers.name;
      if (this.options.page) {
        root = "views/" + this.answers.name + "-view";
      }
      return this.fs.copyTpl(this.templatePath('default/**/*'), this.destinationPath(this.conf.folder + "/" + root), {
        c: this.conf
      });
    },
    "directive-modules.coffee": function() {
      var content, dest;
      if (this.options.page) {
        return;
      }
      dest = this.destinationPath(this.conf.folder + "/directive-modules.coffee");
      content = "Module = angular.module \"" + this.conf.angularModuleName + ".Directives\", [";
      _.forEach(this.moduleNames, function(moduleName) {
        return content += "\n  require './" + moduleName + "'";
      });
      content += "\n]\n\nmodule.exports = Module.name";
      return this.fs.write(dest, content);
    },
    "test-page-components.jade": function() {
      var content, dest;
      if (this.options.page) {
        return;
      }
      dest = this.destinationPath(this.conf.folder + "/views/test-page/test-page-components.jade");
      content = "";
      _.forEach(this.moduleNames, (function(_this) {
        return function(moduleName) {
          return content += "div(" + _this.conf.appNameFQ + "-" + _this.answers.name + ")\n";
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
