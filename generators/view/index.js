var GarlicWebappPageGenerator, _, chalk, fs, generatorLib, gulpFilter, gulpRename, path, spawn, util, yeoman;

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

GarlicWebappPageGenerator = yeoman.generators.Base.extend({
  initializing: {
    init: function() {
      return console.log(chalk.magenta('You\'re using the GarlicTech webapp view generator.'));
    }
  },
  prompting: function() {
    var cb, done;
    done = this.async();
    cb = (function(_this) {
      return function(answers) {
        _this.answers = answers;
        _this.composeWith('garlic-webapp:directive', {
          options: {
            view: true,
            answers: answers
          }
        });
        return done();
      };
    })(this);
    return this.prompt({
      type: 'input',
      name: 'name',
      message: 'view name, without -view (like foo-bar):',
      required: true
    }, cb.bind(this));
  },
  writing: {
    createConfig: function() {
      return generatorLib.createDirectiveConfig.bind(this)();
    },
    protractor: function() {
      var pagesFilter;
      pagesFilter = gulpFilter(['**/view.coffee', '**/scenarios.coffee'], {
        restore: true
      });
      this.registerTransformStream(pagesFilter);
      this.registerTransformStream(gulpRename((function(_this) {
        return function(path) {
          return path.basename = _this.answers.name + "." + path.basename;
        };
      })(this)));
      this.fs.copyTpl(this.templatePath('e2e/**/*'), this.destinationPath("./e2e"), {
        c: this.conf
      });
      return this.registerTransformStream(pagesFilter.restore);
    },
    "views/index.coffee": function() {
      var content, headerDirectiveName, replacedTextRequire, replacedTextState;
      path = this.destinationPath("./src/views/index.coffee");
      content = fs.readFileSync(path, 'utf8');
      headerDirectiveName = (_.kebabCase(this.conf.angularModuleName)) + "-main-header";
      replacedTextState = ".state '" + this.answers.name + "',\n    url: '/" + this.answers.name + "'\n    views:\n      'header':\n        template: '<" + headerDirectiveName + "></" + headerDirectiveName + ">'\n      'main':\n        template: '<" + this.conf.directiveNameKC + "-view></" + this.conf.directiveNameKC + "-view>'\n\n  #===== yeoman hook state =====#";
      content = content.replace('#===== yeoman hook state =====#', replacedTextState);
      replacedTextRequire = "require './" + this.answers.name + "-view'\n  #===== yeoman hook require =====#";
      content = content.replace('#===== yeoman hook require =====#', replacedTextRequire);
      return fs.writeFileSync(path, content, 'utf8');
    }
  }
});

module.exports = GarlicWebappPageGenerator;
