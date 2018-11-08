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
        default : 'v11.0.2'
        message : 'Docker workflow version?'
        store   : true
      }
    ], cb.bind @


  writing:
    createConfig: ->
      generatorLib.createConfig.bind(@)()
      match = /(.*) angular/.exec @appname
      appname = if match then match[1] else @appname
      @conf.appname = @answers.appname
      @conf.dockerRepo = @answers.dockerRepo
      @conf.distImageName = "#{@conf.dockerRepo}/#{@conf.appNameKC}"
      @conf.e2eTesterName = "#{@conf.scope}.#{@conf.appNameKC}.e2e-tester"
      @conf.dockerWorkflowVersion = @answers.dockerWorkflowVersion
      @conf.selectorPrefix = "app"

      @config.set
        scope: @answers.scope


    mainFiles: ->
      cb = @async()
      @fs.copyTpl @templatePath('default/**/*'), @destinationPath("./"), {conf: @conf}
      @fs.copyTpl @templatePath('dotfiles/_npmignore'), @destinationPath("./.npmignore"), {conf: @conf}
      @fs.copyTpl @templatePath('dotfiles/_gitignore'), @destinationPath("./.gitignore"), {conf: @conf}
      @fs.copyTpl @templatePath('dotfiles/_env'), @destinationPath("./.env"), {conf: @conf}
      @fs.copyTpl @templatePath('dotfiles/_package.json'), @destinationPath("./package.json"), {conf: @conf}
      cb()


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

    "subrepos": ->
      done = @async()
      generatorLib.execute "git add ."
      generatorLib.execute "git commit -m 'Initial commit'"
      generatorLib.execute "git checkout -b staging"
      generatorLib.execute "git subrepo clone git@github.com:garlictech/workflows-scripts.git workflows-scripts"
      generatorLib.execute "git subrepo clone git@github.com:garlictech/forms-ngx.git  src/subrepos/forms-ngx"
      generatorLib.execute "git subrepo clone git@github.com:garlictech/localize-ngx.git  src/subrepos/localize-ngx"
      generatorLib.execute "pushd docker; ln -sf ../workflows-scripts/webclient/docker/* .; popd"
      generatorLib.execute "mkdir -p hooks/travis; pushd hooks/travis; ln -sf ../workflows-scripts/webclient/hooks/travis/* .; popd"
      done()

    "build": ->
      done = @async()
      generatorLib.execute "npm install"
      generatorLib.execute "npm run build"
      generatorLib.execute "npm run setup"
      generatorLib.execute "npm install"
      done()


module.exports = GarlicWebappGenerator
