var GarlicWebappGithubGenerator, _, chalk, generatorLib, path, util, yeoman;

util = require('util');

path = require('path');

yeoman = require('yeoman-generator');

chalk = require('chalk');

_ = require('lodash');

generatorLib = require('../lib');

GarlicWebappGithubGenerator = yeoman.generators.Base.extend({
  initializing: {
    init: function() {
      console.log(chalk.magenta('You\'re using the GarlicTech travis preparator.'));
      return generatorLib.createConfig.bind(this)();
    }
  },
  prompting: function() {
    var cb, done, questions, ref, ref1;
    done = this.async();
    this.answers = {};
    cb = (function(_this) {
      return function(answers) {
        _this.answers = _.assign(_this.answers, answers);
        return done();
      };
    })(this);
    questions = [
      {
        type: 'input',
        name: 'githubToken',
        "default": process.env.GITHUB_TOKEN,
        message: "Enter the github personal token:",
        store: true
      }, {
        type: 'input',
        name: 'githubUser',
        "default": process.env.GITHUB_USER,
        message: "Enter the github user:",
        store: true
      }
    ];
    if (((ref = this.options.answers) != null ? ref.dockerUser : void 0) != null) {
      this.answers.dockerUser = this.options.answers.dockerUser;
    } else {
      questions.push({
        type: 'input',
        name: 'dockerUser',
        "default": process.env.DOCKER_USER,
        message: "Docker private repo username: (we take the default from the environment variable DOCKER_USER):",
        store: true
      });
    }
    if (((ref1 = this.options.answers) != null ? ref1.dockerPassword : void 0) != null) {
      this.answers.dockerPassword = this.options.answers.dockerPassword;
    } else {
      questions.push({
        type: 'input',
        name: 'dockerPassword',
        "default": process.env.DOCKER_PASSWORD,
        message: "Docker private repo password: (we take the default from the environment variable DOCKER_PASSWORD):",
        store: true
      });
    }
    return this.prompt(questions, cb.bind(this));
  },
  writing: {
    createConfig: function() {
      var done;
      done = this.async();
      this.conf.dockerUser = this.answers.dockerUser;
      this.conf.dockerPassword = this.answers.dockerPassword;
      this.conf.githubToken = this.answers.githubToken;
      this.conf.githubUser = this.answers.githubUser;
      return done();
    },
    mainFiles: function() {
      this.fs.copyTpl(this.templatePath('default/**/*'), this.destinationPath("./"), {
        c: this.conf
      });
      return this.fs.copyTpl;
    }
  },
  end: {
    executeScript: function() {
      var done;
      done = this.async();
      generatorLib.execute(". ./travis_config.sh");
      generatorLib.execute("rm ./travis_config.sh");
      return done();
    }
  }
});

module.exports = GarlicWebappGithubGenerator;
