util = require('util')
path = require('path')
yeoman = require('yeoman-generator')
chalk = require('chalk')
_ = require 'lodash'
jsonfile = require 'jsonfile'
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


    "package.json": ->
      cb = @async()
      pjson = jsonfile.readFileSync @destinationPath("./package.json")

      _.forEach ['start', 'stop', 'unittest', 'build', 'e2etest', 'bash', 'gulp'], (label) ->
        _.set pjson, "scripts.#{label}", "docker/#{label}.sh"

      _.forEach ['start', 'unittest'], (label) ->
        _.set pjson, "scripts.#{label}:docker", "scripts/#{label}.sh"

      _.set pjson, "scripts.setup-dev", "scripts/setup-dev.sh"
  
      jsonfile.spaces = 2
      jsonfile.writeFileSync @destinationPath("./package.json"), pjson
      cb()


    compositions: ->
      @composeWith 'garlic-webapp:commitizen'
      @composeWith 'garlic-webapp:semantic-release'
      

module.exports = GarlicWebappGithubGenerator
