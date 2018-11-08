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
        "default": 'v11.0.2',
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
      this.conf.appname = this.answers.appname;
      this.conf.dockerRepo = this.answers.dockerRepo;
      this.conf.distImageName = this.conf.dockerRepo + "/" + this.conf.appNameKC;
      this.conf.e2eTesterName = this.conf.scope + "." + this.conf.appNameKC + ".e2e-tester";
      this.conf.dockerWorkflowVersion = this.answers.dockerWorkflowVersion;
      this.conf.selectorPrefix = "app";
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
      this.fs.copyTpl(this.templatePath('dotfiles/_npmignore'), this.destinationPath("./.npmignore"), {
        conf: this.conf
      });
      this.fs.copyTpl(this.templatePath('dotfiles/_gitignore'), this.destinationPath("./.gitignore"), {
        conf: this.conf
      });
      this.fs.copyTpl(this.templatePath('dotfiles/_env'), this.destinationPath("./.env"), {
        conf: this.conf
      });
      this.fs.copyTpl(this.templatePath('dotfiles/_package.json'), this.destinationPath("./package.json"), {
        conf: this.conf
      });
      return cb();
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
    "subrepos": function() {
      var done;
      done = this.async();
      generatorLib.execute("git add .");
      generatorLib.execute("git commit -m 'Initial commit'");
      generatorLib.execute("git checkout -b staging");
      generatorLib.execute("git subrepo clone git@github.com:garlictech/workflows-scripts.git workflows-scripts");
      generatorLib.execute("git subrepo clone git@github.com:garlictech/forms-ngx.git  src/subrepos/forms-ngx");
      generatorLib.execute("git subrepo clone git@github.com:garlictech/localize-ngx.git  src/subrepos/localize-ngx");
      generatorLib.execute("pushd docker; ln -sf ../workflows-scripts/webclient/docker/* .; popd");
      generatorLib.execute("mkdir -p hooks/travis; pushd hooks/travis; ln -sf ../workflows-scripts/webclient/hooks/travis/* .; popd");
      return done();
    },
    "build": function() {
      var done;
      done = this.async();
      generatorLib.execute("npm install");
      generatorLib.execute("npm run build");
      generatorLib.execute("npm run setup");
      generatorLib.execute("npm install");
      return done();
    }
  }
});

module.exports = GarlicWebappGenerator;
