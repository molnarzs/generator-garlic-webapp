util = require('util')
path = require('path')
yeoman = require('yeoman-generator')
chalk = require('chalk')
spawn = require('child_process').spawn
_ = require 'lodash'
fs = require 'fs'
path = require 'path'
generatorLib = require '../lib'

GarlicWebappPaycapSharedComponentGenerator = yeoman.generators.Base.extend
  initializing:
    init: ->
      @conf = @config.getAll()
      console.log chalk.magenta 'You\'re using the GarlicTech webapp Angular 2 component generator for Paycap.'


  prompting: ->
    done = @async()
    cb = (answers) =>
      @answers = answers
      done()

    @prompt [{
      type    : 'list'
      name    : 'project'
      choices : ['client', 'admin']
      default : 'client'
      message : 'Project: '
      required: true
      store   : true
    }, {
      type    : 'input'
      name    : 'baseFolder'
      default : ''
      message : 'Base folder relative to src/app: '
      required: true
      store   : true
    }, {
      type    : 'input'
      name    : 'name'
      message : 'Component name without the component suffix (like foo-bar): '
      required: true
    }], cb.bind @


  writing:
    createConfig: ->
      @conf = _.assign @conf, generatorLib.createConfig.bind(@)()
      @conf.componentName = _.upperFirst _.camelCase "#{@answers.name}-component"
      @conf.baseFolder = @answers.baseFolder
      @conf.moduleName = _.upperFirst _.camelCase "#{@answers.name}-module"
      @conf.selector = "pay-#{@answers.project}-#{@answers.name}"
      @conf.nativeSelector = "pay-native-#{@answers.name}"
      @conf.componentSlug = "#{@answers.name}"
      @conf.templateType = 'html'


    sharedFiles: ->
      @fs.copyTpl @templatePath('shared/**/*'), @destinationPath("./src/common/native/#{@answers.baseFolder}/#{@answers.name}"), {c: @conf}

    appFiles: ->
      @fs.copyTpl @templatePath('app/**/*'), @destinationPath("./src/app/#{@answers.baseFolder}/#{@answers.name}"), {c: @conf}

    templateFiles: ->
      @fs.copyTpl @templatePath("#{@conf.templateType}/**/*"), @destinationPath("./src/app/#{@answers.baseFolder}/#{@answers.name}"), {c: @conf}


module.exports = GarlicWebappPaycapSharedComponentGenerator
