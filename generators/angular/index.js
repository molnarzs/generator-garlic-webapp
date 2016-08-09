var GarlicWebappAngularGenerator, chalk, yeoman;

yeoman = require('yeoman-generator');

chalk = require('chalk');

GarlicWebappAngularGenerator = yeoman.generators.Base.extend({
  initializing: {
    init: function() {
      this.conf = this.config.getAll();
      return console.log(chalk.magenta('You\'re adding AngularJS stuff to your app.'));
    }
  },
  install: {
    dependencies: function() {
      this.npmInstall(['angular', 'angular-ui-router', 'angular-sanitize', 'angular-messages', 'angular-aria'], {
        'save': true
      });
      return this.npmInstall('angular-mocks', {
        'saveDev': true
      });
    }
  }
});

module.exports = GarlicWebappAngularGenerator;
