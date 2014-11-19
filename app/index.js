var GarlicWebappGenerator, chalk, execute, path, sh, spawn, util, yeoman;

util = require('util');

path = require('path');

yeoman = require('yeoman-generator');

chalk = require('chalk');

spawn = require('child_process').spawn;

sh = require('execSync');

execute = function(command) {
  var result;
  result = sh.exec(command);
  return console.log(result.stdout);
};

GarlicWebappGenerator = yeoman.generators.Base.extend({
  init: function() {
    this.githubAuthtoken = this["arguments"][0];
    this.pkg = yeoman.file.readJSON(path.join(__dirname, '../package.json'));
    this.config.set({
      appName: this.appname,
      css: ['bootstrap'],
      scaffolds: ['']
    });
    console.log(this.yeoman);
    return console.log(chalk.magenta('You\'re using the GarlicTech webapp generator.'));
  },
  saveConfig: function() {
    return this.config.save();
  },
  scaffoldFolders: function() {
    this.mkdir("./frontend");
    this.mkdir("./frontend/modules");
    this.mkdir("./frontend/resources");
    this.mkdir("./frontend/styles");
    this.mkdir("./backend/config");
    this.mkdir("./backend/config/env");
    this.mkdir("./backend/modules");
    this.mkdir("./features");
    this.mkdir("./features/step_definitions");
    this.mkdir("./features/support");
    return this.mkdir("./logs");
  },
  copyMainFiles: function() {
    this.config = this.config.getAll();
    return this.directory("./default", "./");
  },
  runNpm: function() {
    var done, seleniumLogdir, seleniumLogdirLink;
    if (!this.options['skip-install']) {
      done = this.async();
      console.log("\nRunning NPM Install. Bower is next.\n");
      seleniumLogdir = path.join(this.destinationRoot(), 'node_modules', 'selenium-server', 'logs');
      seleniumLogdirLink = path.join(this.destinationRoot(), 'logs', 'selenium');
      return this.npmInstall("", (function(_this) {
        return function() {
          spawn('ln', ['-sf', seleniumLogdir, seleniumLogdirLink], {
            stdio: 'inherit'
          });
          return done();
        };
      })(this));
    }
  },
  runBower: function() {
    var done;
    if (!this.options['skip-install']) {
      done = this.async();
      console.log("\nRunning Bower:\n");
      return this.bowerInstall("", function() {
        console.log("\nAll set! Type: gulp serve\n");
        return done();
      });
    }
  },
  runGit: function() {
    var done;
    done = this.async();
    if (!this.githubAuthtoken) {
      console.log("\nWarning: Github repo not created: github oauth token is unknown or invalid.\n");
      return;
    }
    console.log("\nCreating GitHub repo...\n");
    execute("curl https://api.github.com/orgs/garlictech/repos -u " + this.githubAuthtoken + ":x-oauth-basic -d \'{\"name\":\"" + this.appname + "\"}\'");
    execute("git init");
    execute("git remote add origin https://github.com/garlictech/" + this.appname + ".git");
    execute("git add .");
    execute("git commit -m 'Initial version.'");
    execute('git push -u origin master');
    return done();
  }
});

module.exports = GarlicWebappGenerator;
