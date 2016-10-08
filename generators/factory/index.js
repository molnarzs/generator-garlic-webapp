var GarlicWebappFactoryGenerator, _, chalk, fs, path, spawn, util, yeoman;

util = require('util');

path = require('path');

yeoman = require('yeoman-generator');

chalk = require('chalk');

spawn = require('child_process').spawn;

_ = require('lodash');

fs = require('fs');

GarlicWebappFactoryGenerator = yeoman.generators.Base.extend({
  initializing: {
    init: function() {
      this.conf = this.config.getAll();
      return console.log(chalk.magenta('You\'re using the GarlicTech webapp factory generator.'));
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
      message: 'Module name (like foo-factory): ',
      required: true
    }, cb.bind(this));
  },
  writing: {
    createConfig: function() {
      this.conf = _.assign(this.conf, generatorLib.createConfig.bind(this)());
      this.moduleNames = this.conf.angularModules.factories;
      this.moduleNames.push(this.answers.name);
      this.conf.factoryName = _.upperFirst(_.camelCase(this.answers.name));
      this.conf.moduleName = this.conf.angularModuleName + "." + this.conf.factoryName;
      return this.conf.factoryNameFQ = this.conf.moduleName;
    },
    mainFiles: function() {
      return this.fs.copyTpl(this.templatePath('default/**/*'), this.destinationPath("./src/" + this.answers.name), {
        c: this.conf
      });
    },
    "factory-modules.coffee": function() {
      var content, dest;
      dest = this.destinationPath("./src/factory-modules.coffee");
      content = "Module = angular.module \"" + this.conf.appNameCC + ".factories\", [";
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

module.exports = GarlicWebappFactoryGenerator;
