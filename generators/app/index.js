var GarlicWebappGenerator, _, chalk, execute, path, spawn, util, yeoman;

util = require('util');

path = require('path');

yeoman = require('yeoman-generator');

chalk = require('chalk');

spawn = require('child_process').spawn;

_ = require('lodash');

execute = function(command) {
  var result;
  result = sh.exec(command);
  return console.log(result.stdout);
};

GarlicWebappGenerator = yeoman.generators.Base.extend({
  initializing: {
    init: function() {
      this.config.set({
        appName: this.appname
      });
      return console.log(chalk.magenta('You\'re using the GarlicTech webapp generator.'));
    }
  },
  writing: {
    mainFiles: function() {
      this.config = this.config.getAll();
      this.fs.copyTpl(this.templatePath('default/**/*'), this.destinationPath("./"), {
        appName: this.config.appName,
        appNameCC: _.camelCase(this.config.appName)
      });
      return this.fs.copy(this.templatePath('default_assets/**/*'), this.destinationPath("./frontend/src/"));
    },
    "frontend/components.json": function() {
      var dest;
      dest = this.destinationPath("./frontend/src/components.json");
      if (!this.fs.exists(dest)) {
        return this.fs.writeJSON(dest, {
          uiModuleNames: [],
          factoryModuleNames: [],
          serviceModuleNames: []
        });
      }
    },
    "frontend/ui-modules.coffee": function() {
      var dest;
      dest = this.destinationPath("./frontend/src/ui-modules.coffee");
      if (!this.fs.exists(dest)) {
        return this.fs.write(dest, "Module = angular.module \"" + this.config.appName + "-ui\", []\nmodule.exports = Module.name");
      }
    },
    "frontend/service-modules.coffee": function() {
      var dest;
      dest = this.destinationPath("./frontend/src/service-modules.coffee");
      if (!this.fs.exists(dest)) {
        return this.fs.write(dest, "Module = angular.module \"" + this.config.appName + "-services\", []\nmodule.exports = Module.name");
      }
    },
    "frontend/factory-modules.coffee": function() {
      var dest;
      dest = this.destinationPath("./frontend/src/factory-modules.coffee");
      if (!this.fs.exists(dest)) {
        return this.fs.write(dest, "Module = angular.module \"" + this.config.appName + "-factories\", []\nmodule.exports = Module.name");
      }
    },
    "frontend/views/test-page/test-page-components.jade": function() {
      var dest;
      dest = this.destinationPath("./frontend/src/views/test-page/test-page-components.jade");
      if (!this.fs.exists(dest)) {
        return this.fs.write(dest, "");
      }
    }
  },
  install: {
    linkGtComplib: function() {
      if (!this.options['skip-install']) {
        console.log("\nLinking gt-complib.\n");
        return this.spawnCommand('npm', ['link', 'gt-complib']);
      }
    },
    dependencies: function() {
      if (!this.options['skip-install']) {
        return this.installDependencies();
      }
    },
    selenium: function() {
      if (!this.options['skip-install']) {
        console.log("\Updating selenium...\n");
        return this.spawnCommand("node_modules/protractor/bin/webdriver-manager", ["update", "--standalone"]);
      }
    }
  }
});

module.exports = GarlicWebappGenerator;
