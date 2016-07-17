var GarlicWebappGenerator, _, chalk, execute, mkdirp, path, util, yeoman;

util = require('util');

path = require('path');

yeoman = require('yeoman-generator');

chalk = require('chalk');

_ = require('lodash');

mkdirp = require('mkdirp');

execute = require('child_process').execSync;

GarlicWebappGenerator = yeoman.generators.Base.extend({
  initializing: {
    init: function() {
      this.config.set({
        appName: this.appname,
        angularModules: {
          ui: [],
          services: [],
          factories: [],
          pages: [],
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
  writing: {
    mainFiles: function() {
      var cb;
      cb = this.async();
      this.conf = this.config.getAll();
      this.fs.copyTpl(this.templatePath('default/**/*'), this.destinationPath("./"), {
        appName: _.kebabCase(this.conf.appName),
        appNamecC: _.camelCase(this.conf.appName),
        appNameCC: _.capitalize(_.camelCase(this.conf.appName)),
        appNameAsIs: this.conf.appName
      });
      this.fs.copy(this.templatePath('default_assets/**/*'), this.destinationPath("./src/"));
      return cb();
    },
    "src/ui-modules.coffee": function() {
      var dest;
      dest = this.destinationPath("./src/ui-modules.coffee");
      if (!this.fs.exists(dest)) {
        return this.fs.write(dest, "Module = angular.module \"" + this.conf.appName + "-ui\", []\nmodule.exports = Module.name");
      }
    },
    "src/service-modules.coffee": function() {
      var dest;
      dest = this.destinationPath("./src/service-modules.coffee");
      if (!this.fs.exists(dest)) {
        return this.fs.write(dest, "Module = angular.module \"" + this.conf.appName + "-services\", []\nmodule.exports = Module.name");
      }
    },
    "src/factory-modules.coffee": function() {
      var dest;
      dest = this.destinationPath("./src/factory-modules.coffee");
      if (!this.fs.exists(dest)) {
        return this.fs.write(dest, "Module = angular.module \"" + this.conf.appName + "-factories\", []\nmodule.exports = Module.name");
      }
    },
    "src/provider-modules.coffee": function() {
      var dest;
      dest = this.destinationPath("./src/provider-modules.coffee");
      if (!this.fs.exists(dest)) {
        return this.fs.write(dest, "Module = angular.module \"" + this.conf.appName + "-providers\", []\nmodule.exports = Module.name");
      }
    },
    "src/views/test-page/test-page-components.jade": function() {
      var dest;
      dest = this.destinationPath("./src/views/test-page/test-page-components.jade");
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
      var cb;
      cb = this.async();
      if (!this.options['skip-install']) {
        this.installDependencies();
      }
      return cb();
    }
  }
});

module.exports = GarlicWebappGenerator;
