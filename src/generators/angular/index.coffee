yeoman = require('yeoman-generator')
chalk = require('chalk')

GarlicWebappAngularGenerator = yeoman.generators.Base.extend
  initializing:
    init: ->
      @conf = @config.getAll()
      console.log chalk.magenta 'You\'re adding AngularJS stuff to your app.'


  install:
    dependencies: ->
      @npmInstall ['angular', 'angular-ui-router', 'angular-sanitize', 'angular-messages', 'angular-aria'], { 'save': true }
      @npmInstall 'angular-mocks', { 'saveDev': true }


module.exports = GarlicWebappAngularGenerator
