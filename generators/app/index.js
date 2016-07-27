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
  prompting: function() {
    var cb, done;
    done = this.async();
    cb = (function(_this) {
      return function(answers) {
        _this.answers = answers;
        _this.appname = _this.answers.name;
        _this.config.set({
          scope: _this.answers.scope
        });
        return done();
      };
    })(this);
    return this.prompt([
      {
        type: 'input',
        name: 'scope',
        "default": 'garlictech',
        message: 'Project scope'
      }
    ], cb.bind(this));
  },
  writing: {
    mainFiles: function() {
      var appNameFQ, cb;
      cb = this.async();
      this.conf = this.config.getAll();
      appNameFQ = this.conf.scope + "-" + this.conf.appName;
      this.fs.copyTpl(this.templatePath('default/**/*'), this.destinationPath("./"), {
        scopeCC: _.capitalize(this.conf.scope),
        appName: _.kebabCase(appNameFQ),
        appNamecC: _.camelCase(appNameFQ),
        appNameCC: _.capitalize(_.camelCase(appNameFQ)),
        appNameAsIs: this.conf.appName,
        scope: this.conf.scope
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
