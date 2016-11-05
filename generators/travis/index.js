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
    var cb, done, questions, ref, ref1, ref2, ref3;
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
        name: 'dockerMachine',
        "default": "",
        message: "Enter the SSH access of the docker machine this repo uses. Keep it empty if the project does not use docker docker machine. Example: root@api.gtrack.events",
        store: true
      }
    ];
    if (((ref = this.options.answers) != null ? ref.slackToken : void 0) != null) {
      this.answers.slackToken = this.options.answers.slackToken;
    } else {
      questions.push({
        type: 'input',
        name: process.env["SLACK_TOKEN_" + this.conf.scopeCC],
        "default": slackToken,
        message: "Slack token: (we take the default from the environment variable SLACK_TOKEN_" + this.conf.scopeCC + "):",
        store: true
      });
    }
    if (((ref1 = this.options.answers) != null ? ref1.dockerRepo : void 0) != null) {
      this.answers.dockerRepo = this.options.answers.dockerRepo;
    } else {
      questions.push({
        type: 'input',
        name: 'dockerRepo',
        "default": "docker." + this.conf.scope + ".com",
        message: 'Docker repo:',
        store: true
      });
    }
    if (((ref2 = this.options.answers) != null ? ref2.dockerUser : void 0) != null) {
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
    if (((ref3 = this.options.answers) != null ? ref3.dockerPassword : void 0) != null) {
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
