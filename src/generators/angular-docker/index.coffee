util = require('util')
path = require('path')
yeoman = require('yeoman-generator')
chalk = require('chalk')
_ = require 'lodash'
generatorLib = require '../lib'

GarlicWebappGithubGenerator = yeoman.generators.Base.extend
  initializing:

    init: ->
      console.log chalk.magenta 'You\'re using the GarlicTech webapp / angular docker files generator.'
      generatorLib.createConfig.bind(@)()

  writing:
    mainFiles: ->
      dest = "./"

      @fs.copyTpl @templatePath('default/**/*'), @destinationPath(dest), {c: @conf}
      @fs.copyTpl @templatePath('dotfiles/_dockerignore'), @destinationPath("#{dest}/.dockerignore"), {c: @conf}

module.exports = GarlicWebappGithubGenerator
