var GarlicWebappServerGenerator, chalk, generatorLib, jsonfile, mkdirp, path, util, yeoman;

util = require('util');

path = require('path');

yeoman = require('yeoman-generator');

chalk = require('chalk');

mkdirp = require('mkdirp');

jsonfile = require('jsonfile');

generatorLib = require('../lib');

GarlicWebappServerGenerator = yeoman.generators.Base.extend({
  initializing: function() {
    this.config.set({
      appname: this.appname
    });
    return console.log(chalk.magenta('You\'re using the GarlicTech server generator.'));
  },
  prompting: function() {
    var cb, dockerRepo, done;
    done = this.async();
    cb = (function(_this) {
      return function(answers) {
        _this.answers = answers;
        _this.config.set({
          scope: _this.answers.scope
        });
        _this.config.set({
          type: _this.answers.type
        });
        return done();
      };
    })(this);
    dockerRepo = process.env.DOCKER_REPO;
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
        choices: ['express', 'loopback', 'library'],
        "default": 'loopback',
        message: 'Project type:',
        store: true
      }, {
        type: 'input',
        name: 'dockerMachine',
        message: "Enter the SSH access of the docker machine this repo uses. Keep it empty if the project does not use docker docker machine. Example: root@api.gtrack.events",
        store: true
      }, {
        type: 'input',
        name: 'dockerRepo',
        "default": dockerRepo,
        message: 'Docker repo:',
        store: true
      }, {
        type: 'confirm',
        name: 'isTravis',
        "default": true,
        message: 'Configure travis.ci?',
        store: true
      }
    ], cb.bind(this));
  },
  writing: {
    loopback: function() {
      var cb;
      if (this.answers.projectType === 'loopback') {
        cb = this.async();
        console.log(chalk.red('Now, we call the loopback generator. Do not change the project name! If it asks, overwrite all the files!'));
        this.composeWith('loopback', {
          options: {
            "skip-install": true
          }
        });
        generatorLib.execute("rm -rf client");
        return cb();
      }
    },
    createConfig: function() {
      generatorLib.createConfig.bind(this)();
      this.conf.dockerMachine = this.answers.dockerMachine;
      this.conf.dockerRepo = this.answers.dockerRepo != null ? this.answers.dockerRepo : "docker.garlictech.com";
      if (this.answers.projectType === "express") {
        this.conf.type = "server-common";
      }
      if (this.answers.projectType === "loopback") {
        return this.conf.type = "server-loopback";
      }
    },
    mainFiles: function() {
      var cb;
      cb = this.async();
      this.fs.copyTpl(this.templatePath('default/**/*'), this.destinationPath("./"), {
        c: this.conf
      });
      this.fs.copyTpl(this.templatePath('dotfiles/common/_npmignore'), this.destinationPath("./.npmignore"), {
        c: this.conf
      });
      this.fs.copyTpl(this.templatePath('dotfiles/common/_gitignore'), this.destinationPath("./.gitignore"), {
        c: this.conf
      });
      return cb();
    },
    serverFiles: function() {
      var cb;
      if (this.answers.projectType !== 'library') {
        cb = this.async();
        this.fs.copyTpl(this.templatePath('server/**/*'), this.destinationPath("./"), {
          c: this.conf
        });
        this.fs.copyTpl(this.templatePath('dotfiles/server/_package.json'), this.destinationPath("./package.json"), {
          c: this.conf
        });
        this.fs.copyTpl(this.templatePath('dotfiles/server/_dockerignore'), this.destinationPath("./.dockerignore"), {
          c: this.conf
        });
        return cb();
      }
    },
    libraryFiles: function() {
      var cb;
      if (this.answers.projectType === 'library') {
        cb = this.async();
        this.fs.copyTpl(this.templatePath('library/**/*'), this.destinationPath("./"), {
          c: this.conf
        });
        this.fs.copyTpl(this.templatePath('dotfiles/library/_package.json'), this.destinationPath("./package.json"), {
          c: this.conf
        });
        return cb();
      }
    }
  },
  end: {
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
    }
  },
  install: {
    setupEnvironment: function() {
      var cb;
      cb = this.async();
      generatorLib.execute("npm run setup");
      return cb();
    }
  }
});

module.exports = GarlicWebappServerGenerator;
