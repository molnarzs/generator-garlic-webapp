util = require('util')
path = require('path')
yeoman = require('yeoman-generator')
chalk = require('chalk')
_ = require 'lodash'
jsonfile = require 'jsonfile'
execute = require('child_process').execSync
generatorLib = require '../lib'

GarlicWebappGenerator = yeoman.generators.Base.extend
  initializing: ->
    @config.set
      appname: @appname
      angularModules:
        directives: []
        services: []
        components: []

    console.log chalk.magenta 'You\'re using the GarlicTech angular 2 app generator.'

  prompting: ->
    done = @async()
    cb = (answers) =>
      @answers = answers
      @config.set {scope: @answers.scope}
      @config.set {projectType: @answers.projectType}
      done()

    @prompt [{
        type    : 'input',
        name    : 'scope',
        default : 'garlictech',
        message : 'Project scope (company github team):'
        store   : true
      }, {
        type    : 'list'
        name    : 'projectType'
        default : 'module'
        choices : ['module', 'site']
        message : 'Project type:'
        store   : true
      }, {
        type    : 'input'
        name    : 'dockerRepo'
        default : 'docker.io'
        message : 'Docker repo:'
        store   : true
      }, {
        type    : 'confirm'
        name    : 'isRepo'
        default : true
        message : 'Create github repo?'
        store   : true
      }, {
        type    : 'confirm'
        name    : 'isTravis'
        default : true
        message : 'Configure travis.ci?'
        store   : true
      }, {
        type    : 'input'
        name    : 'dockerWorkflowVersion'
        default : 19
        message : 'Docker workflow version?'
        store   : true
      }
    ], cb.bind @


  writing:
    createConfig: ->
      generatorLib.createConfig.bind(@)()
      match = /(.*) angular/.exec @appname
      appname = if match then match[1] else @appname
      @conf.dockerRepo = @answers.dockerRepo
      @conf.webpackServerName = "#{@conf.scope}.#{@conf.appNameKC}.webpack-server"
      @conf.distImageName = "#{@conf.dockerRepo}/#{@conf.appNameKC}"
      @conf.e2eTesterName = "#{@conf.scope}.#{@conf.appNameKC}.e2e-tester"
      @conf.dockerWorkflowVersion = @answers.dockerWorkflowVersion

      if @conf.projectType is 'module'
        @conf.selectorPrefix = "#{@conf.scope}-#{@conf.appNameKC}"
      else
        @conf.selectorPrefix = "app"

      @config.set
        scope: @answers.scope


    mainFiles: ->
      cb = @async()
      @fs.copyTpl @templatePath('default/**/*'), @destinationPath("./"), {conf: @conf}
      @fs.copyTpl @templatePath('dotfiles/_package.json'), @destinationPath("./package.json"), {conf: @conf}
      @fs.copyTpl @templatePath('dotfiles/_npmignore'), @destinationPath("./.npmignore"), {conf: @conf}
      @fs.copyTpl @templatePath('dotfiles/_gitignore'), @destinationPath("./.gitignore"), {conf: @conf}
      cb()


    projectTypeFiles: ->
      if @conf.projectType is 'module'
        @fs.copyTpl @templatePath('module/**/*'), @destinationPath("./"), {conf: @conf}
      else
        @fs.copyTpl @templatePath('site/**/*'), @destinationPath("./"), {conf: @conf}


    dotfiles: ->
      @fs.copy @templatePath('default/.*'), @destinationPath("./")


  end:
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

    commitizen: ->
      cb = @async()
      @composeWith 'garlic-webapp:commitizen', options: {answers: @answers}
      cb()


    "semantic-release": ->
      cb = @async()
      @composeWith 'garlic-webapp:semantic-release', options: {answers: @answers}
      cb()


module.exports = GarlicWebappGenerator
