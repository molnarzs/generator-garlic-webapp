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
      this.conf = this.config.getAll();
      console.log(chalk.magenta('You\'re using the GarlicTech webapp UI generator.'));
      this.moduleNames = this.conf.angularModules.ui;
      this.conf.appNameKC = _.kebabCase(this.conf.appName);
      return this.conf.appNameCC = _.capitalize(_.camelCase(this.conf.appName));
    }
  },
  prompting: function() {
    var cb, done;
    done = this.async();
    cb = (function(_this) {
      return function(answers) {
        done();
        _this.answers = answers;
        _this.moduleNames.push(_this.answers.name);
        _this.conf.moduleNameCC = _.capitalize(_.camelCase(_this.answers.name));
        _this.conf.moduleNameKC = _.kebabCase(_this.answers.name);
        _this.conf.directiveNameCC = "" + _this.conf.appNameCC + _this.conf.moduleNameCC;
        return _this.conf.directiveNameKC = _this.conf.appNameKC + "-" + _this.conf.moduleNameKC;
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
    mainFiles: function() {
      return this.fs.copyTpl(this.templatePath('default/**/*'), this.destinationPath("./frontend/src/" + this.answers.name), {
        moduleNameFQ: this.conf.appNameCC + "." + this.conf.moduleNameCC,
        directiveNameCC: this.conf.directiveNameCC,
        directiveNameKC: this.conf.directiveNameKC
      });
    },
    "ui-modules.coffee": function() {
      var content, dest;
      dest = this.destinationPath("./frontend/src/ui-modules.coffee");
      content = "Module = angular.module \"" + this.conf.appNameCC + ".ui\", [";
      _.forEach(this.moduleNames, function(moduleName) {
        return content += "\n  require './" + moduleName + "'";
      });
      content += "\n]\n\nmodule.exports = Module.name";
      return this.fs.write(dest, content);
    },
    "test-page-components.jade": function() {
      var content, dest;
      dest = this.destinationPath("./frontend/src/views/test-page/test-page-components.jade");
      content = "";
      _.forEach(this.moduleNames, (function(_this) {
        return function(moduleName) {
          return content += "div(" + _this.conf.appNameKC + "-" + moduleName + ")\n";
        };
      })(this));
      return this.fs.write(dest, content);
    },
    protractor: function() {
      var pagesFilter;
      pagesFilter = gulpFilter(['**/page.coffee', '**/scenarios.coffee'], {
        restore: true
      });
      this.registerTransformStream(pagesFilter);
      this.registerTransformStream(gulpRename((function(_this) {
        return function(path) {
          return path.basename = _this.answers.name + "." + path.basename;
        };
      })(this)));
      this.fs.copyTpl(this.templatePath('protractor/**/*'), this.destinationPath("./frontend/src/test/protractor"), {
        pageName: this.answers.name,
        pageNameCC: _.capitalize(_.camelCase(this.answers.name))
      });
      return this.registerTransformStream(pagesFilter.restore);
    },
    saveConfig: function() {
      return this.config.set('angularModules', this.conf.angularModules);
    }
  }
});

module.exports = GarlicWebappUiGenerator;
