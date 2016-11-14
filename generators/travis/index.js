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
      console.log(chalk.magenta('You\'re using the GarlicTech travis config generator.'));
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
    generatorLib.pushToQuestions.bind(this)(questions, 'dockerMachine', 'input', "", "Enter the SSH access of the docker machine this repo uses. Keep it empty if the project does not use docker docker machine. Example: root@api.gtrack.events", true);
    generatorLib.pushToQuestions.bind(this)(questions, 'slackToken', 'input', process.env["SLACK_TOKEN_" + this.conf.scopeCC], "Slack token: (we take the default from the environment variable SLACK_TOKEN_" + this.conf.scopeCC + "):", true);
    generatorLib.pushToQuestions.bind(this)(questions, 'dockerRepo', 'input', "docker." + this.conf.scope + ".com", 'Docker repo:', true);
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
      this.conf.slackToken = this.answers.slackToken;
      this.conf.dockerMachine = this.answers.dockerMachine;
      this.conf.dockerRepo = this.answers.dockerRepo;
      return done();
    },
    mainFiles: function() {
      this.fs.copyTpl(this.templatePath('default/**/*'), this.destinationPath("./"), {
        c: this.conf
      });
      return this.fs.copyTpl(this.templatePath('dotfiles/_travis.yml'), this.destinationPath("./.travis.yml"), {
        c: this.conf
      });
    }
  },
  end: {
    travisPrepare: function() {
      var done;
      done = this.async();
      this.composeWith('garlic-webapp:travis-prepare', {
        options: {
          answers: this.answers
        }
      });
      return done();
    },
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
