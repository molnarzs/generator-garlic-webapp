var GarlicWebappPageGenerator, _, chalk, fs, gulpFilter, gulpRename, gulpReplace, path, spawn, util, yeoman;

util = require('util');

path = require('path');

yeoman = require('yeoman-generator');

chalk = require('chalk');

spawn = require('child_process').spawn;

_ = require('lodash');

fs = require('fs');

gulpFilter = require('gulp-filter');

gulpRename = require('gulp-rename');

gulpReplace = require('gulp-replace');

GarlicWebappPageGenerator = yeoman.generators.Base.extend({
  initializing: {
    init: function() {
      return console.log(chalk.magenta('You\'re using the GarlicTech webapp pages generator.'));
    }
  },
  prompting: function() {
    var cb, done;
    done = this.async();
    cb = (function(_this) {
      return function(answers) {
        _this.answers = answers;
        _this.composeWith('garlic-webapp:ui', {
          options: {
            page: true,
            answers: answers
          }
        });
        return done();
      };
    })(this);
    return this.prompt({
      type: 'input',
      name: 'name',
      message: 'Page name, without -page (like foo-bar):',
      required: true
    }, cb.bind(this));
  },
  writing: {
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
      this.fs.copyTpl(this.templatePath('protractor/**/*'), this.destinationPath("./src/test/protractor"), {
        pageName: this.answers.name,
        pageNameCC: (_.capitalize(_.camelCase(this.answers.name))) + "Page"
      });
      return this.registerTransformStream(pagesFilter.restore);
    },
    "views/index.coffee": function() {
      var conf, content, replacedTextRequire, replacedTextState;
      path = this.destinationPath("./src/views/index.coffee");
      content = fs.readFileSync(path, 'utf8');
      conf = this.config.getAll();
      replacedTextState = ".state '" + this.answers.name + "',\n    url: '/" + this.answers.name + "'\n    views:\n      'main':\n        template: '<div " + conf.appName + "-" + this.answers.name + "-page></div>'\n\n  #===== yeoman hook state =====#";
      content = content.replace('#===== yeoman hook state =====#', replacedTextState);
      replacedTextRequire = "require './" + this.answers.name + "-page'\n  #===== yeoman hook require =====#";
      content = content.replace('#===== yeoman hook require =====#', replacedTextRequire);
      return fs.writeFileSync(path, content, 'utf8');
    }
  }
});

module.exports = GarlicWebappPageGenerator;
