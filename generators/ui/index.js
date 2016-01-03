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
      this.config.set({
        appName: this.appname
      });
      return console.log(chalk.magenta('You\'re using the GarlicTech webapp UI generator.'));
    }
  },
  prompting: function() {
    var cb, done;
    done = this.async();
    cb = (function(_this) {
      return function(answers) {
        done();
        return _this.answers = answers;
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
        moduleName: this.answers.name,
        moduleNameCC: _.camelCase(this.answers.name)
      });
    },
    "frontend/components.json": function() {
      var dest;
      dest = this.destinationPath("./frontend/src/components.json");
      this.moduleNamesObj = this.fs.readJSON(dest);
      this.moduleNamesObj.uiModuleNames.push(this.answers.name);
      return this.fs.writeJSON(dest, this.moduleNamesObj);
    },
    "ui-modules.coffee": function() {
      var content, dest;
      dest = this.destinationPath("./frontend/src/ui-modules.coffee");
      content = "Module = angular.module \"" + this.config.appName + "-ui\", [";
      _.forEach(this.moduleNamesObj.uiModuleNames, function(moduleName) {
        return content += "\n  require './" + moduleName + "'";
      });
      content += "\n]\n\nmodule.exports = Module.name";
      return this.fs.write(dest, content);
    },
    "test-page-components.jade": function() {
      var content, dest;
      dest = this.destinationPath("./frontend/src/views/test-page/test-page-components.jade");
      content = "";
      _.forEach(this.moduleNamesObj.uiModuleNames, (function(_this) {
        return function(moduleName) {
          return content += "div(" + _this.config.appName + "-" + moduleName + ")\n";
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
    }
  }
});

module.exports = GarlicWebappUiGenerator;
