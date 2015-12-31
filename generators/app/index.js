var GarlicWebappGenerator, chalk, execute, path, spawn, util, yeoman;

util = require('util');

path = require('path');

yeoman = require('yeoman-generator');

chalk = require('chalk');

spawn = require('child_process').spawn;

execute = function(command) {
  var result;
  result = sh.exec(command);
  return console.log(result.stdout);
};

GarlicWebappGenerator = yeoman.generators.Base.extend({
  initializing: {
    init: function() {
      this.config.set({
        appName: this.appname
      });
      return console.log(chalk.magenta('You\'re using the GarlicTech webapp generator.'));
    }
  },
  writing: {
    mainFiles: function() {
      this.config = this.config.getAll();
      this.fs.copyTpl(this.templatePath('default/**/*'), this.destinationPath("./"), {
        appName: this.config.appName
      });
      return this.fs.copy(this.templatePath('default_assets/**/*'), this.destinationPath("./frontend/src/"));
    }
  },
  install: {
    linkGtComplib: function() {
      if (!this.options['skip-install']) {
        console.log("\nLinking gt-complib.\n");
        return this.spawnCommand('npm', ['link', 'gt-complib']);
      }
    },
    dependencies: function() {
      if (!this.options['skip-install']) {
        return this.installDependencies();
      }
    }
  }
});

module.exports = GarlicWebappGenerator;
