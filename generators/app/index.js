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
  initializing: function() {
    this.config.set({
      appname: this.appname,
      angularModules: {
        directives: [],
        services: [],
        factories: [],
        views: [],
        providers: []
      }
    });
    return console.log(chalk.magenta('You\'re using the GarlicTech webapp generator.'));
  },
  prompting: function() {
    var cb, done;
    done = this.async();
    cb = (function(_this) {
      return function(answers) {
        _this.answers = answers;
        _this.config.set({
          scope: _this.answers.scope
        });
        _this.config.set({
          projectType: _this.answers.projectType
        });
        return done();
      };
    })(this);
    return this.prompt([
      {
        type: 'input',
        name: 'scope',
        "default": 'garlictech',
        message: 'Project scope (company github team):',
        store: true
      }, {
        type: 'list',
        name: 'projectType',
        "default": 'module',
        choices: ['module', 'site'],
        message: 'Project type:',
        store: true
      }, {
        type: 'confirm',
        name: 'isRepo',
        "default": true,
        message: 'Create github repo?',
        store: true
      }
    ], cb.bind(this));
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
      this.fs.copyTpl(this.templatePath('dotfiles/_npmignore'), this.destinationPath("./.npmignore"), {
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
    projectTypeFiles: function() {
      if (this.conf.projectType === 'module') {
        return this.fs.copyTpl(this.templatePath('module/**/*'), this.destinationPath("./"), {
          conf: this.conf
        });
      } else {
        return this.fs.copyTpl(this.templatePath('site/**/*'), this.destinationPath("./"), {
          conf: this.conf
        });
      }
    },
    dotfiles: function() {
      return this.fs.copy(this.templatePath('default/.*'), this.destinationPath("./"));
    },
    repo: function() {
      if (this.answers.isRepo) {
        return this.composeWith('garlic-webapp:github');
      }
    },
    docker: function() {
      return this.composeWith('garlic-webapp:angular-docker');
    }
  }
});

module.exports = GarlicWebappGenerator;
