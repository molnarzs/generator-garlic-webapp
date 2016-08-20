var GarlicWebappGithubGenerator, chalk, generatorLib, path, util, yeoman;

util = require('util');

path = require('path');

yeoman = require('yeoman-generator');

chalk = require('chalk');

generatorLib = require('../lib');

GarlicWebappGithubGenerator = yeoman.generators.Base.extend({
  initializing: {
    init: function() {
      console.log(chalk.magenta('You\'re using the GarlicTech webapp generator.'));
      return generatorLib.createConfig.bind(this)();
    }
  },
  prompting: function() {
    var cb, devTeamId, done, githubToken, npmToken, slackToken, slackWebhookUrl;
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
    return this.prompt([
      {
        type: 'input',
        name: 'githubToken',
        "default": githubToken,
        message: 'Github token (we take the default from the environment variable GITHUB_TOKEN):',
        store: true
      }, {
        type: 'input',
        name: 'npmToken',
        "default": npmToken,
        message: "NPM token: (we take the default from the environment variable NPM_TOKEN_" + this.conf.scopeCC + "):",
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
      }
    ], cb.bind(this));
  },
  writing: {
    runRemoteGit: function() {
      var _configureTravis, done, repoCreateCmd, webhook, webhookCreateCmd;
      done = this.async();
      _configureTravis = (function(_this) {
        return function() {
          console.log(chalk.blue("\nConfiguring travis...\n"));
          generatorLib.execute("travis enable");
          generatorLib.execute("travis encrypt " + _this.answers.npmToken + " --add deploy.api_key");
          generatorLib.execute("travis env set NPM_TOKEN " + _this.answers.npmToken);
          return generatorLib.execute("travis encrypt \"" + _this.conf.scope + ":" + _this.answers.slackToken + "\" --add notifications.slack.rooms");
        };
      })(this);
      console.log(chalk.blue("\nCreating GitHub repo...\n"));
      repoCreateCmd = "curl https://api.github.com/orgs/" + this.conf.scope + "/repos -u " + this.answers.githubToken + ":x-oauth-basic -d \'{\"name\":\"" + this.conf.appNameKC + "\", \"private\": true, \"team_id\": " + this.answers.devTeam + "}\'";
      generatorLib.execute(repoCreateCmd);
      generatorLib.execute("git init");
      generatorLib.execute("git remote add origin https://github.com/" + this.conf.scope + "/" + this.conf.appNameKC + ".git");
      _configureTravis();
      console.log(chalk.blue("\nCommitting initial version...\n"));
      generatorLib.execute("git add .");
      generatorLib.execute("git commit -m 'Initial version.'");
      generatorLib.execute('git push -u origin master');
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
      webhookCreateCmd = "curl https://api.github.com/repos/" + this.conf.scope + "/" + this.conf.appNameKC + "/hooks -u " + this.answers.githubToken + ":x-oauth-basic -d \'" + (JSON.stringify(webhook)) + "\'";
      generatorLib.execute(webhookCreateCmd);
      return done();
    }
  }
});

module.exports = GarlicWebappGithubGenerator;
