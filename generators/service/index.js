var GarlicWebappServiceGenerator, _, chalk, fs, generatorLib, path, spawn, util, yeoman;

util = require('util');

path = require('path');

yeoman = require('yeoman-generator');

chalk = require('chalk');

spawn = require('child_process').spawn;

_ = require('lodash');

fs = require('fs');

generatorLib = require('../lib');

GarlicWebappServiceGenerator = yeoman.generators.Base.extend({
  initializing: {
    init: function() {
      this.conf = this.config.getAll();
      return console.log(chalk.magenta('You\'re using the GarlicTech webapp service generator.'));
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
    return this.prompt({
      type: 'input',
      name: 'name',
      message: 'Module name (like foo-service): ',
      required: true
    }, cb.bind(this));
  },
  writing: {
    createConfig: function() {
      this.conf = _.assign(this.conf, generatorLib.createConfig.bind(this)());
      this.moduleNames = this.conf.angularModules.services;
      this.moduleNames.push(this.answers.name);
      this.conf.serviceName = _.upperFirst(_.camelCase(this.answers.name));
      this.conf.moduleName = this.conf.angularModuleName + "." + this.conf.serviceName;
      return this.conf.serviceNameFQ = this.conf.moduleName;
    },
    mainFiles: function() {
      return this.fs.copyTpl(this.templatePath('default/**/*'), this.destinationPath("./src/" + this.answers.name), {
        c: this.conf
      });
    },
    "service-modules.coffee": function() {
      var content, dest;
      dest = this.destinationPath("./src/service-modules.coffee");
      content = "Module = angular.module \"" + this.conf.angularModuleName + ".Services\", [";
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

module.exports = GarlicWebappServiceGenerator;
