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
      console.log(chalk.magenta('You\'re using the GarlicTech webapp service generator.'));
      this.moduleNames = this.conf.angularModules.services;
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
        _this.conf.serviceName = _.capitalize(_.camelCase(_this.answers.name));
        _this.conf.moduleName = _this.conf.appNameCC + "." + _this.conf.serviceName;
        return _this.conf.serviceNameFQ = _this.conf.appNameCC + "." + _this.conf.serviceName;
      };
    })(this);
    return this.prompt({
      type: 'input',
      name: 'name',
      message: 'Module name (like foo-service): ',
      required: true
    }, cb.bind(this));
  },
  writing: {
    mainFiles: function() {
      return this.fs.copyTpl(this.templatePath('default/**/*'), this.destinationPath("./client/" + this.answers.name), {
        c: this.conf
      });
    },
    "service-modules.coffee": function() {
      var content, dest;
      dest = this.destinationPath("./client/service-modules.coffee");
      content = "Module = angular.module \"" + this.conf.appNameCC + ".services\", [";
      _.forEach(this.moduleNames, function(moduleName) {
        return content += "\n  require './" + moduleName + "'";
      });
      content += "\n]\n\nmodule.exports = Module.name";
      return this.fs.write(dest, content);
    },
    saveConfig: function() {
      return this.config.set('angularModules', this.conf.angularModules);
    }
  }
});

module.exports = GarlicWebappUiGenerator;
