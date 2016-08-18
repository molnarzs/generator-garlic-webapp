var GarlicWebappGenerator, _, chalk, execute, generatorLib, mkdirp, path, util, yeoman;

util = require('util');

path = require('path');

yeoman = require('yeoman-generator');

chalk = require('chalk');

_ = require('lodash');

mkdirp = require('mkdirp');

execute = require('child_process').execSync;

generatorLib = require('../lib');

GarlicWebappGenerator = yeoman.generators.Base.extend({
  initializing: {
    init: function() {
      this.config.set({
        appname: this.appname,
        angularModules: {
          directives: [],
          services: [],
          factories: [],
          views: [],
          providers: []
        },
        server: {
          components: []
        },
        common: {
          components: []
        }
      });
      return console.log(chalk.magenta('You\'re using the GarlicTech webapp generator.'));
    }
  },
  prompting: function() {
    return generatorLib.prompting.bind(this)();
  },
  writing: {
    createConfig: function() {
      var angularModuleName;
      generatorLib.createConfig.bind(this)();
      angularModuleName = this.conf.scopeCC + "." + (_.capitalize(_.camelCase(this.appname)));
      this.conf.angularModuleName = angularModuleName;
      return this.config.set({
        angularModuleName: angularModuleName,
        scope: this.answers.scope
      });
    },
    mainFiles: function() {
      var cb;
      cb = this.async();
      this.fs.copyTpl(this.templatePath('default/**/*'), this.destinationPath("./"), {
        conf: this.conf
      });
      this.fs.copyTpl(this.templatePath('dotfiles/_travis.yml'), this.destinationPath("./.travis.yml"), {
        conf: this.conf
      });
      this.fs.copy(this.templatePath('default_assets/**/*'), this.destinationPath("./src/"));
      return cb();
    },
    "src/directive-modules.coffee": function() {
      var dest;
      dest = this.destinationPath("./src/directive-modules.coffee");
      if (!this.fs.exists(dest)) {
        return this.fs.write(dest, "Module = angular.module \"" + this.conf.angularModuleName + "/Directives\", []\nmodule.exports = Module.name");
      }
    },
    "src/service-modules.coffee": function() {
      var dest;
      dest = this.destinationPath("./src/service-modules.coffee");
      if (!this.fs.exists(dest)) {
        return this.fs.write(dest, "Module = angular.module \"" + this.conf.angularModuleName + "/Services\", []\nmodule.exports = Module.name");
      }
    },
    "src/factory-modules.coffee": function() {
      var dest;
      dest = this.destinationPath("./src/factory-modules.coffee");
      if (!this.fs.exists(dest)) {
        return this.fs.write(dest, "Module = angular.module \"" + this.conf.angularModuleName + "/Factories\", []\nmodule.exports = Module.name");
      }
    },
    "src/provider-modules.coffee": function() {
      var dest;
      dest = this.destinationPath("./src/provider-modules.coffee");
      if (!this.fs.exists(dest)) {
        return this.fs.write(dest, "Module = angular.module \"" + this.conf.angularModuleName + "/Providers\", []\nmodule.exports = Module.name");
      }
    },
    "src/views/test-page/test-view-components.jade": function() {
      var dest;
      dest = this.destinationPath("./src/views/test-view/test-view-components.jade");
      if (!this.fs.exists(dest)) {
        return this.fs.write(dest, "");
      }
    },
    dotfiles: function() {
      return this.fs.copy(this.templatePath('default/.*'), this.destinationPath("./"));
    }
  },
  install: {
    dependencies: function() {
      return generatorLib.dependencies.bind(this)();
    }
  }
});

module.exports = GarlicWebappGenerator;
