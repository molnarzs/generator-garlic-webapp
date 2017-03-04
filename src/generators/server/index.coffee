util = require('util')
path = require('path')
yeoman = require('yeoman-generator')
chalk = require('chalk')
mkdirp = require 'mkdirp'
fs = require 'fs-extra'
jsonfile = require 'jsonfile'
generatorLib = require '../lib'

GarlicWebappServerGenerator = yeoman.generators.Base.extend
  initializing: ->
    @config.set
      appname: @appname

    console.log chalk.magenta 'You\'re using the GarlicTech server generator.'


  prompting: ->
    done = @async()
    cb = (answers) =>
      @answers = answers
      @config.set {scope: @answers.scope}
      @config.set {projectType: @answers.projectType}
      done()

    dockerRepo = process.env.DOCKER_REPO

    @prompt [{
        type    : 'input',
        name    : 'scope',
        default : 'garlictech',
        message : 'Project scope (company github team):'
        store   : true
      }, {
        type    : 'list',
        name    : 'projectType',
        choices : ['express', 'loopback', 'library']
        default : 'loopback',
        message : 'Project type:'
        store   : true
      }, {
        type    : 'input'
        name    : 'dockerMachine'
        message : "Enter the SSH access of the docker machine this repo uses. Keep it empty if the project does not use docker docker machine. Example: root@api.gtrack.events"
        store   : true
      }, {
        type    : 'input'
        name    : 'dockerRepo'
        default : dockerRepo
        message : 'Docker repo:'
        store   : true
      }, {
        type    : 'confirm'
        name    : 'isTravis'
        default : true
        message : 'Configure travis.ci?'
        store   : true
      }, {
        type    : 'confirm'
        name    : 'isRepo'
        default : true
        message : 'Create github repo?'
        store   : true
      }, {
        type    : 'input'
        name    : 'dockerWorkflowVersion'
        default : 28
        message : 'Docker workflow version?'
        store   : true
      }
    ], cb.bind @


  writing:
    loopback: ->
      if @answers.projectType is 'loopback'
        cb = @async()
        console.log chalk.red 'Now, we call the loopback generator. Do not change the project name! If it asks, overwrite all the files!'
        @composeWith 'loopback', {options: {"skip-install": true}}
        generatorLib.execute "rm -rf client"
        cb()


    createConfig: ->
      generatorLib.createConfig.bind(@)()
      @conf.dockerWorkflowVersion = @answers.dockerWorkflowVersion
      @conf.dockerMachine = @answers.dockerMachine
      @conf.dockerRepo = if @answers.dockerRepo? then @answers.dockerRepo else "docker.garlictech.com"
      @conf.workflowsServerType = if @answers.projectType is 'loopback' then "workflows-loopback-server" else "workflows-server"

      if @answers.projectType is "express" then @conf.type = "server-common"
      if @answers.projectType is "loopback" then @conf.type = "server-loopback"


    mainFiles: ->
      cb = @async()
      @fs.copyTpl @templatePath('default/**/*'), @destinationPath("./"), {c: @conf}
      @fs.copyTpl @templatePath('dotfiles/common/_npmignore'), @destinationPath("./.npmignore"), {c: @conf}
      @fs.copyTpl @templatePath('dotfiles/common/_gitignore'), @destinationPath("./.gitignore"), {c: @conf}
      cb()


    serverFiles: ->
      if @answers.projectType isnt 'library'
        cb = @async()
        @fs.copyTpl @templatePath('server/**/*'), @destinationPath("./"), {c: @conf}
        @fs.copyTpl @templatePath('dotfiles/server/_package.json'), @destinationPath("./package.json"), {c: @conf}
        @fs.copyTpl @templatePath('dotfiles/server/_dockerignore'), @destinationPath("./.dockerignore"), {c: @conf}
        @fs.copyTpl @templatePath('dotfiles/server/_env'), @destinationPath("./.env"), {c: @conf}
        cb()


    libraryFiles: ->
      if @answers.projectType is 'library'
        cb = @async()
        @fs.copyTpl @templatePath('library/**/*'), @destinationPath("./"), {c: @conf}
        @fs.copyTpl @templatePath('dotfiles/library/_package.json'), @destinationPath("./package.json"), {c: @conf}
        @fs.copyTpl @templatePath('dotfiles/library/_env'), @destinationPath("./.env"), {c: @conf}
        cb()


    expressFiles: ->
      if @answers.projectType is 'express'
        cb = @async()
        @fs.copyTpl @templatePath('express/**/*'), @destinationPath("./"), {c: @conf}
        cb()


  end:
    loopbackChanges: ->
      if @answers.projectType is 'loopback'
        cb = @async()
        file = @destinationPath "./server/server.js"
        data = fs.readFileSync(file).toString().split "\n"
        data.splice 6, 0, "require('./app-config-local')(app);"
        text = data.join "\n"
        fs.writeFileSync file, text
        cb()


    commitizen: ->
      cb = @async()
      @composeWith 'garlic-webapp:commitizen', options: {answers: @answers}
      cb()


    repo: ->
      if @answers.isRepo
        cb = @async()
        @composeWith 'garlic-webapp:github', options: {answers: @answers}
        cb()


    travis: ->
      if @answers.isTravis
        if not @answers.isRepo
          console.log chalk.yellow 'WARNING: You disabled github repo creation. If the repo does not exist, the Travis commands will fail!'

        cb = @async()
        @composeWith 'garlic-webapp:travis', options: {answers: @answers}
        cb()

module.exports = GarlicWebappServerGenerator
