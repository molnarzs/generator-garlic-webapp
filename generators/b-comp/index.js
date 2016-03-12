var GarlicWebappUiGenerator, _, chalk, fs, path, spawn, util, yeoman;

util = require('util');

path = require('path');

yeoman = require('yeoman-generator');

chalk = require('chalk');

spawn = require('child_process').spawn;

_ = require('lodash');

fs = require('fs');

GarlicWebappUiGenerator = yeoman.generators.Base.extend({
  initializing: {
    init: function() {
      this.conf = this.config.getAll();
      console.log(chalk.magenta('You\'re using the GarlicTech webapp background component service.'));
      return this.serverComponents = this.conf.server;
    }
  },
  prompting: function() {
    var cb, done;
    done = this.async();
    cb = (function(_this) {
      return function(answers) {
        done();
        _this.answers = answers;
        _this.conf.componentNameCC = _.capitalize(_.camelCase(_this.answers.name));
        _this.conf.componentName = _this.answers.name;
        return _this.serverComponents.components.push(_this.conf.componentName);
      };
    })(this);
    return this.prompt({
      type: 'input',
      name: 'name',
      message: 'Component name (like foo-component): ',
      required: true
    }, cb.bind(this));
  },
  writing: {
    mainFiles: function() {
      return this.fs.copyTpl(this.templatePath('default/**/*'), this.destinationPath("./server/src/" + this.conf.componentName), {
        c: this.conf
      });
    },
    saveConfig: function() {
      return this.config.set('server', this.serverComponents);
    }
  }
});

module.exports = GarlicWebappUiGenerator;
