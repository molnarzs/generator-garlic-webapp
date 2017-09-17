var GarlicWebappGithubGenerator, chalk, generatorLib, path, util, yeoman;

util = require('util');

path = require('path');

yeoman = require('yeoman-generator');

chalk = require('chalk');

generatorLib = require('../lib');

GarlicWebappGithubGenerator = yeoman.generators.Base.extend({
  initializing: {
    init: function() {
      console.log(chalk.magenta('You\'re using the GarlicTech github repo generator.'));
      return generatorLib.createConfig.bind(this)();
    }
  },
  prompting: function() {
    var cb, devTeamId, dockerPassword, dockerUser, done, githubToken, npmToken, slackToken, slackWebhookUrl;
    done = this.async();
    cb = (function(_this) {
      return function(answers) {
        _this.answers = answers;
        return done();
      };
    })(this);
    githubToken = process.env.GITHUB_TOKEN;
    npmToken = process.env["NPM_TOKEN_" + this.conf.scopeCC];
    slackToken = process.env["SLACK_TOKEN_" + this.conf.scopeCC];
    slackWebhookUrl = process.env["SLACK_WEBHOOK_URL_" + this.conf.scopeCC];
    devTeamId = process.env["DEV_TEAM_ID_" + this.conf.scopeCC];
    dockerUser = process.env.DOCKER_USER;
    dockerPassword = process.env.DOCKER_PASSWORD;
    return this.prompt([
      {
        type: 'input',
        name: 'githubToken',
        "default": githubToken,
        message: 'Github token (we take the default from the environment variable GITHUB_TOKEN):',
        store: true
      }, {
        type: 'input',
        name: 'slackToken',
        "default": slackToken,
        message: "Slack token: (we take the default from the environment variable SLACK_TOKEN_" + this.conf.scopeCC + "):",
        store: true
      }, {
        type: 'input',
        name: 'slackWebhook',
        "default": slackWebhookUrl,
        message: "Slack webhook url: (we take the default from the environment variable SLACK_WEBHOOK_URL_" + this.conf.scopeCC + "):",
        store: true
      }, {
        type: 'input',
        name: 'devTeam',
        "default": devTeamId,
        message: "Development team ID: (we take the default from the environment variable DEV_TEAM_ID_" + this.conf.scopeCC + "):",
        store: true
      }, {
        type: 'input',
        name: 'dockerUser',
        "default": dockerUser,
        message: "Docker private repo username: (we take the default from the environment variable DOCKER_USER):",
        store: true
      }, {
        type: 'input',
        name: 'dockerPassword',
        "default": dockerPassword,
        message: "Docker private repo password: (we take the default from the environment variable DOCKER_PASSWORD):",
        store: true
      }, {
        type: 'confirm',
        name: 'isPrivate',
        "default": true,
        message: "Private repo?",
        store: true
      }
    ], cb.bind(this));
  },
  writing: {
    mainFiles: function() {
      this.fs.copyTpl(this.templatePath('default/**/*'), this.destinationPath("./"), {
        c: this.conf
      });
      return this.fs.copyTpl;
    },
    runRemoteGit: function() {
      var done, repoCreateCmd, webhook;
      done = this.async();
      console.log(chalk.blue("\nCreating GitHub repo...\n"));
      repoCreateCmd = "curl https://api.github.com/orgs/" + this.conf.scope + "/repos -u " + this.answers.githubToken + ":x-oauth-basic -d \'{\"name\":\"" + this.conf.appNameKC + "\", \"private\": " + this.answers.isPrivate + ", \"team_id\": " + this.answers.devTeam + "}\'";
      generatorLib.execute(repoCreateCmd);
      generatorLib.execute("git init");
      generatorLib.execute("git remote add origin https://github.com/" + this.conf.scope + "/" + this.conf.appNameKC + ".git");
      console.log(chalk.blue("\Configuring webhooks...\n"));
      webhook = {
        name: "web",
        config: {
          url: this.answers.slackWebhook,
          content_type: 'json'
        },
        active: true,
        events: ['issues', 'issue_comment', 'member', 'pull_request', 'pull_request_review_comment', 'deployment']
      };
      console.log(chalk.blue("\nRepo is created. Nothing is committed yet!\n"));
      return done();
    }
  },
  end: {
    executeLabelCreation: function() {
      var done;
      done = this.async();
      generatorLib.execute(". ./github-prepare.sh");
      generatorLib.execute("rm ./github-prepare.sh");
      return done();
    }
  }
});

module.exports = GarlicWebappGithubGenerator;
