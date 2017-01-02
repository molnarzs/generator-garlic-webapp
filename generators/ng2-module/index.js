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
      return console.log(chalk.magenta('You\'re using the GarlicTech webapp Angular 2 module generator.'));
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
        message: 'Module name without "module" (like foo-bar): ',
        required: true
      }, {
        type: 'confirm',
        name: 'isRouting',
        message: 'Generate routing?',
        required: true,
        "default": false,
        store: true
      }
    ], cb.bind(this));
  },
  writing: {
    createConfig: function() {
      this.conf = _.assign(this.conf, generatorLib.createConfig.bind(this)());
      this.conf.moduleName = _.upperFirst(_.camelCase(this.answers.name + "-module"));
      return this.conf.routingModuleName = this.conf.moduleName + "Routing";
    },
    mainFiles: function() {
      console.log(this.answers.isRouting);
      if (this.answers.isRouting) {
        return this.fs.copyTpl(this.templatePath('with-routing/**/*'), this.destinationPath("./" + this.answers.baseFolder + "/" + this.answers.name), {
          c: this.conf
        });
      } else {
        return this.fs.copyTpl(this.templatePath('default/**/*'), this.destinationPath("./" + this.answers.baseFolder + "/" + this.answers.name), {
          c: this.conf
        });
      }
    }
  }
});

module.exports = GarlicWebappNg2ServiceGenerator;
