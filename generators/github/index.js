var GarlicWebappGithubGenerator, chalk, execute, path, util, yeoman;

util = require('util');

path = require('path');

yeoman = require('yeoman-generator');

chalk = require('chalk');

execute = require('child_process').execSync;

GarlicWebappGithubGenerator = yeoman.generators.Base.extend({
  initializing: {
    init: function() {
      console.log(chalk.magenta('You\'re using the GarlicTech webapp generator.'));
      return this.conf = this.config.getAll();
    }
  },
  prompting: function() {
    var cb, defaultToken, done;
    done = this.async();
    cb = (function(_this) {
      return function(answers) {
        _this.answers = answers;
        return done();
      };
    })(this);
    defaultToken = process.env.GITHUB_TOKEN;
    console.log('X', defaultToken);
    return this.prompt([
      {
        type: 'input',
        name: 'repo',
        "default": 'garlictech',
        message: 'Github repo:',
        store: true
      }, {
        type: 'input',
        name: 'githubToken',
        "default": defaultToken,
        message: 'Github token:',
        store: true
      }
    ], cb.bind(this));
  },
  writing: {
    runRemoteGit: function() {
      var done;
      done = this.async();
      if (this.answers.githubToken == null) {
        console.log("\nWarning: Github repo not created: github oauth token is unknown or invalid.\n");
        return;
      }
      console.log("\nCreating GitHub repo...\n");
      execute("curl https://api.github.com/orgs/" + this.conf.scope + "/repos -u " + this.answers.githubToken + ":x-oauth-basic -d \'{\"name\":\"" + this.conf.appNameKC + "\"}\'");
      execute("git init");
      execute("git remote add origin https://github.com/" + this.conf.scope + "/" + this.conf.appNameKC + ".git");
      execute("git add .");
      execute("git commit -m 'Initial version.'");
      execute('git push -u origin master');
      return done();
    }
  }
});

module.exports = GarlicWebappGithubGenerator;
