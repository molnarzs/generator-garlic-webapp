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
      @conf.webpackServerName = "#{@conf.scope}.#{@conf.appNameKC}.webpack-server"
      @conf.e2eTesterName = "#{@conf.scope}.#{@conf.appNameKC}.e2e-tester"
      @conf.dockerRepo = "docker.#{@conf.scope}.com"

  writing:
    mainFiles: ->
      dest = "./"

      @fs.copyTpl @templatePath('default/**/*'), @destinationPath(dest), {c: @conf}
      @fs.copyTpl @templatePath('dotfiles/_dockerignore'), @destinationPath("#{dest}/.dockerignore"), {c: @conf}

module.exports = GarlicWebappGithubGenerator
