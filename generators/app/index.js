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
        appname: this.appname,
        angularModules: {
          directives: [],
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
      console.log(chalk.magenta('You\'re using the GarlicTech webapp generator.'));
      return this.conf = this.config.getAll();
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
        name: 'scope',
        "default": 'garlictech',
        message: 'Project scope (company github team):'
      }
    ], cb.bind(this));
  },
  writing: {
    createConfig: function() {
      var angularModuleName, appNameAsIs, appNameFQ, appNameFQcC, appNameKC, scopeCC;
      scopeCC = _.capitalize(_.camelCase(this.answers.scope));
      appNameAsIs = scopeCC + " " + this.appname;
      appNameKC = _.kebabCase(this.appname);
      appNameFQ = _.kebabCase(appNameAsIs);
      appNameFQcC = _.camelCase(appNameFQ);
      angularModuleName = scopeCC + "/" + (_.capitalize(_.camelCase(this.appname)));
      console.log("EN", process.env["NPM_TOKEN_" + scopeCC], "NPM_TOKEN_" + scopeCC);
      return this.config.set({
        scope: this.answers.scope,
        scopeCC: scopeCC,
        appNameKC: appNameKC,
        appNameAsIs: appNameAsIs,
        appNameFQ: appNameFQ,
        appNameFQcC: appNameFQcC,
        appNameFQCC: _.capitalize(appNameFQcC),
        angularModuleName: angularModuleName,
        npmToken: process.env["NPM_TOKEN_" + scopeCC],
        slackToken: process.env["SLACK_TOKEN_" + scopeCC]
      });
    },
    mainFiles: function() {
      var cb;
      cb = this.async();
      this.conf = this.config.getAll();
      console.log('C2', this.conf);
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
