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
    var cb, done, questions;
    done = this.async();
    this.answers = {};
    cb = (function(_this) {
      return function(answers) {
        _this.answers = _.assign(_this.answers, answers);
        return done();
      };
    })(this);
    questions = [];
    generatorLib.pushToQuestions.bind(this)(questions, 'dockerUser', 'input', process.env.DOCKER_USER, "Docker private repo username: (we take the default from the environment variable DOCKER_USER):", true);
    generatorLib.pushToQuestions.bind(this)(questions, 'dockerPassword', 'input', process.env.DOCKER_PASSWORD, "Docker private repo password: (we take the default from the environment variable DOCKER_PASSWORD):", true);
    generatorLib.pushToQuestions.bind(this)(questions, 'githubUser', 'input', process.env.GITHUB_USER, "Enter the github user:", true);
    generatorLib.pushToQuestions.bind(this)(questions, 'githubToken', 'input', process.env.GITHUB_TOKEN, "Enter the github personal token:", true);
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
      generatorLib.execute(". ./travis_prepare_config.sh");
      generatorLib.execute("rm ./travis_prepare_config.sh");
      return done();
    }
  }
});

module.exports = GarlicWebappGithubGenerator;
