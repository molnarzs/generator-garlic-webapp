var GarlicWebappNg2ServiceGenerator, _, chalk, fs, generatorLib, path, spawn, util, yeoman;

util = require('util');

path = require('path');

yeoman = require('yeoman-generator');

chalk = require('chalk');

spawn = require('child_process').spawn;

_ = require('lodash');

fs = require('fs');

path = require('path');

generatorLib = require('../lib');

GarlicWebappNg2ServiceGenerator = yeoman.generators.Base.extend({
  initializing: {
    init: function() {
      this.conf = this.config.getAll();
      return console.log(chalk.magenta('You\'re using the GarlicTech webapp Angular 2 component generator.'));
    }
  },
  prompting: function() {
    var cb, done;
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
        name: 'baseFolder',
        "default": 'src/app',
        message: 'Base folder relative to the app root (like src/app): ',
        required: true,
        store: true
      }, {
        type: 'input',
        name: 'name',
        message: 'Component name without the component suffix (like foo-bar): ',
        required: true
      }, {
        type: 'list',
        name: 'templateType',
        "default": 'pug',
        choices: ['pug', 'html'],
        store: true,
        required: true,
        message: 'Template type: '
      }
    ], cb.bind(this));
  },
  writing: {
    createConfig: function() {
      this.conf = _.assign(this.conf, generatorLib.createConfig.bind(this)());
      this.conf.componentName = _.upperFirst(_.camelCase(this.answers.name + "-component"));
      this.conf.selector = this.conf.scope + "-" + this.answers.name;
      return this.conf.templateType = this.answers.templateType;
    },
    mainFiles: function() {
      return this.fs.copyTpl(this.templatePath('default/**/*'), this.destinationPath("./" + this.answers.baseFolder + "/" + this.answers.name), {
        c: this.conf
      });
    },
    templateFiles: function() {
      return this.fs.copyTpl(this.templatePath(this.conf.templateType + "/**/*"), this.destinationPath("./" + this.answers.baseFolder + "/" + this.answers.name), {
        c: this.conf
      });
    }
  }
});

module.exports = GarlicWebappNg2ServiceGenerator;
