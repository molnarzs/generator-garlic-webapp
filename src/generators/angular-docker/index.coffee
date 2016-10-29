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


  prompting: ->
    done = @async()
    cb = (answers) =>
      @answers = answers
      @conf.dockerRepo = answers.dockerRepo
      done()

    if @options.answers?.dockerRepo?
      cb @options.answers
    else
      dockerRepo = "docker.#{@conf.scope}.com"

      @prompt [{
          type    : 'input'
          name    : 'dockerRepo'
          default : dockerRepo
          message : 'Docker repo:'
          store   : true
        }
      ], cb.bind @


  writing:
    mainFiles: ->
      dest = "./"

      @fs.copyTpl @templatePath('default/**/*'), @destinationPath(dest), {c: @conf}
      @fs.copyTpl @templatePath('dotfiles/_dockerignore'), @destinationPath("#{dest}/.dockerignore"), {c: @conf}


    "package.json": ->
      cb = @async()
      pjson = jsonfile.readFileSync @destinationPath("./package.json")

      _.forEach ['start', 'stop', 'unittest', 'build', 'e2etest', 'bash', 'gulp', 'dist'], (label) ->
        _.set pjson, "scripts.#{label}", "docker/#{label}.sh"

      _.forEach ['start', 'unittest', 'dist'], (label) ->
        _.set pjson, "scripts.#{label}:docker", "scripts/#{label}.sh"

      _.set pjson, "scripts.setup-dev", "scripts/setup-dev.sh"
      _.set pjson, "scripts.unittest:single", "export NODE_ENV=test; docker/unittest.sh"

      _.set pjson, "scripts.Build", "npm run build -- --no-cache"
  
      jsonfile.spaces = 2
      jsonfile.writeFileSync @destinationPath("./package.json"), pjson
      cb()


    commitizen: ->
      cb = @async()
      @composeWith 'garlic-webapp:commitizen', options: {answers: @answers}
      cb()


    "semantic-release": ->
      cb = @async()
      @composeWith 'garlic-webapp:semantic-release', options: {answers: @answers}
      cb()
      

module.exports = GarlicWebappGithubGenerator
