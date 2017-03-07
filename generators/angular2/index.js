var GarlicWebappGenerator, _, chalk, execute, generatorLib, jsonfile, path, util, yeoman;

util = require('util');

path = require('path');

yeoman = require('yeoman-generator');

chalk = require('chalk');

_ = require('lodash');

jsonfile = require('jsonfile');

execute = require('child_process').execSync;

generatorLib = require('../lib');

GarlicWebappGenerator = yeoman.generators.Base.extend({
  initializing: function() {
    this.config.set({
      appname: this.appname,
      angularModules: {
        directives: [],
        services: [],
        components: []
      }
    });
    return console.log(chalk.magenta('You\'re using the GarlicTech angular 2 app generator.'));
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
        type: 'input',
        name: 'dockerRepo',
        "default": 'docker.io',
        message: 'Docker repo:',
        store: true
      }, {
        type: 'confirm',
        name: 'isRepo',
        "default": true,
        message: 'Create github repo?',
        store: true
      }, {
        type: 'confirm',
        name: 'isTravis',
        "default": true,
        message: 'Configure travis.ci?',
        store: true
      }, {
        type: 'input',
        name: 'dockerWorkflowVersion',
        "default": 30,
        message: 'Docker workflow version?',
        store: true
      }
    ], cb.bind(this));
  },
  writing: {
    createConfig: function() {
      var appname, match;
      generatorLib.createConfig.bind(this)();
      match = /(.*) angular/.exec(this.appname);
      appname = match ? match[1] : this.appname;
      this.conf.dockerRepo = this.answers.dockerRepo;
      this.conf.webpackServerName = this.conf.scope + "." + this.conf.appNameKC + ".webpack-server";
      this.conf.distImageName = this.conf.dockerRepo + "/" + this.conf.appNameKC;
      this.conf.e2eTesterName = this.conf.scope + "." + this.conf.appNameKC + ".e2e-tester";
      this.conf.dockerWorkflowVersion = this.answers.dockerWorkflowVersion;
      if (this.conf.projectType === 'module') {
        this.conf.selectorPrefix = this.conf.scope + "-" + this.conf.appNameKC;
      } else {
        this.conf.selectorPrefix = "app";
      }
      return this.config.set({
        scope: this.answers.scope
      });
    },
    mainFiles: function() {
      var cb;
      cb = this.async();
      this.fs.copyTpl(this.templatePath('default/**/*'), this.destinationPath("./"), {
        conf: this.conf
      });
      this.fs.copyTpl(this.templatePath('dotfiles/_package.json'), this.destinationPath("./package.json"), {
        conf: this.conf
      });
      this.fs.copyTpl(this.templatePath('dotfiles/_npmignore'), this.destinationPath("./.npmignore"), {
        conf: this.conf
      });
      this.fs.copyTpl(this.templatePath('dotfiles/_gitignore'), this.destinationPath("./.gitignore"), {
        conf: this.conf
      });
      return cb();
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
    }
  },
  end: {
    repo: function() {
      var cb;
      if (this.answers.isRepo) {
        cb = this.async();
        this.composeWith('garlic-webapp:github', {
          options: {
            answers: this.answers
          }
        });
        return cb();
      }
    },
    travis: function() {
      var cb;
      if (this.answers.isTravis) {
        if (!this.answers.isRepo) {
          console.log(chalk.yellow('WARNING: You disabled github repo creation. If the repo does not exist, the Travis commands will fail!'));
        }
        cb = this.async();
        this.composeWith('garlic-webapp:travis', {
          options: {
            answers: this.answers
          }
        });
        return cb();
      }
    },
    commitizen: function() {
      var cb;
      cb = this.async();
      this.composeWith('garlic-webapp:commitizen', {
        options: {
          answers: this.answers
        }
      });
      return cb();
    },
    "semantic-release": function() {
      var cb;
      cb = this.async();
      this.composeWith('garlic-webapp:semantic-release', {
        options: {
          answers: this.answers
        }
      });
      return cb();
    }
  }
});

module.exports = GarlicWebappGenerator;
