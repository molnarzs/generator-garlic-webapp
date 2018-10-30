var GarlicWebappPaycapComponentGenerator, _, chalk, fs, generatorLib, path, spawn, util, yeoman;

util = require('util');

path = require('path');

yeoman = require('yeoman-generator');

chalk = require('chalk');

spawn = require('child_process').spawn;

_ = require('lodash');

fs = require('fs');

path = require('path');

generatorLib = require('../lib');

GarlicWebappPaycapComponentGenerator = yeoman.generators.Base.extend({
  initializing: {
    init: function() {
      this.conf = this.config.getAll();
      return console.log(chalk.magenta('You\'re using the GarlicTech webapp Angular 2 component generator for Paycap.'));
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
        type: 'list',
        name: 'project',
        choices: ['client', 'admin'],
        "default": 'client',
        message: 'Project: ',
        required: true,
        store: true
      }, {
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
      }
    ], cb.bind(this));
  },
  writing: {
    createConfig: function() {
      this.conf = _.assign(this.conf, generatorLib.createConfig.bind(this)());
      this.conf.componentName = _.upperFirst(_.camelCase(this.answers.name + "-component"));
      this.conf.baseFolder = this.answers.baseFolder;
      this.conf.moduleName = _.upperFirst(_.camelCase(this.answers.name + "-module"));
      this.conf.selector = "pay-" + this.answers.project + "-" + this.answers.name;
      return this.conf.templateType = 'pug';
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

module.exports = GarlicWebappPaycapComponentGenerator;
