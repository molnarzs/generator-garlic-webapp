var GarlicWebappGenerator, _, chalk, path, util, yeoman;

util = require('util');

path = require('path');

yeoman = require('yeoman-generator');

chalk = require('chalk');

_ = require('lodash');

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
      console.log(this.config.appName);
      console.log(_.camelCase(this.config.appName));
      console.log(_.kebabCase(this.config.appName));
      this.config = this.config.getAll();
      this.fs.copyTpl(this.templatePath('default/**/*'), this.destinationPath("./"), {
        appName: _.kebabCase(this.config.appName),
        appNameCC: _.camelCase(this.config.appName),
        appNameAsIs: this.config.appName
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
    dependencies: function() {
      var cb;
      cb = this.async();
      if (!this.options['skip-install']) {
        this.installDependencies();
      }
      return cb();
    }
  },
  end: {
    linkGtComplib: function() {
      var cb;
      cb = this.async();
      if (!this.options['skip-install']) {
        console.log("\nLinking gt-complib.\n");
        this.spawnCommand('npm', ['link', 'gt-complib']);
      }
      return cb();
    }
  }
});

module.exports = GarlicWebappGenerator;
