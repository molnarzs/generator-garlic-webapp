var GarlicWebappUiGenerator, _, chalk, fs, gulpFilter, gulpRename, path, spawn, util, yeoman;

util = require('util');

path = require('path');

yeoman = require('yeoman-generator');

chalk = require('chalk');

spawn = require('child_process').spawn;

_ = require('lodash');

fs = require('fs');

gulpFilter = require('gulp-filter');

gulpRename = require('gulp-rename');

GarlicWebappUiGenerator = yeoman.generators.Base.extend({
  initializing: {
    init: function() {
      if (!this.options.page) {
        console.log(chalk.magenta('You\'re using the GarlicTech webapp UI generator.'));
      }
      this.conf = this.config.getAll();
      this.moduleNames = this.options.page ? this.conf.angularModules.pages : this.conf.angularModules.ui;
      this.conf.appNameKC = _.kebabCase(this.conf.appName);
      return this.conf.appNameCC = _.capitalize(_.camelCase(this.conf.appName));
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
    return this.prompt({
      type: 'input',
      name: 'name',
      message: 'Module name (like foo-component):',
      required: true
    }, cb.bind(this));
  },
  writing: {
    createConfig: function() {
      if (this.options.page) {
        this.answers = this.options.answers;
      }
      this.moduleNames.push(this.answers.name);
      this.conf.moduleNameCC = _.capitalize(_.camelCase(this.answers.name));
      this.conf.moduleNameKC = _.kebabCase(this.answers.name);
      this.conf.directiveNameCC = "" + (_.camelCase(this.conf.appName)) + this.conf.moduleNameCC;
      this.conf.directiveNameKC = this.conf.appNameKC + "-" + this.conf.moduleNameKC;
      if (this.options.page) {
        this.conf.directiveNameCC = this.conf.directiveNameCC + "Page";
        return this.conf.directiveNameKC = this.conf.directiveNameKC + "-page";
      }
    },
    mainFiles: function() {
      var root;
      root = "" + this.answers.name;
      this.conf.moduleNameFQ = this.conf.appNameCC + "." + this.conf.moduleNameCC;
      if (this.options.page) {
        root = "views/" + this.answers.name + "-page";
        this.conf.moduleNameFQ = this.conf.moduleNameFQ + ".page";
      }
      return this.fs.copyTpl(this.templatePath('default/**/*'), this.destinationPath("./src/" + root), {
        c: this.conf
      });
    },
    "ui-modules.coffee": function() {
      var content, dest;
      if (this.options.page) {
        return;
      }
      dest = this.destinationPath("./src/ui-modules.coffee");
      content = "Module = angular.module \"" + this.conf.appNameCC + ".ui\", [";
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
      dest = this.destinationPath("./src/views/test-page/test-page-components.jade");
      content = "";
      _.forEach(this.moduleNames, (function(_this) {
        return function(moduleName) {
          return content += "div(" + _this.conf.appNameKC + "-" + moduleName + ")\n";
        };
      })(this));
      return this.fs.write(dest, content);
    },
    saveConfig: function() {
      return this.config.set('angularModules', this.conf.angularModules);
    }
  }
});

module.exports = GarlicWebappUiGenerator;
