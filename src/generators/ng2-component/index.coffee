util = require('util')
path = require('path')
yeoman = require('yeoman-generator')
chalk = require('chalk')
spawn = require('child_process').spawn
_ = require 'lodash'
fs = require 'fs'
path = require 'path'
generatorLib = require '../lib'

GarlicWebappNg2ServiceGenerator = yeoman.generators.Base.extend
  initializing:
    init: ->
      @conf = @config.getAll()
      console.log chalk.magenta 'You\'re using the GarlicTech webapp Angular 2 component generator.'


  prompting: ->
    done = @async()
    cb = (answers) =>
      @answers = answers
      done()

    @prompt [{
      type    : 'input'
      name    : 'baseFolder'
      default : 'src/app'
      message : 'Base folder relative to the app root (like src/app): '
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
      @conf.selector = "app-#{@conf.scope}-#{@answers.name}"

    mainFiles: ->
      console.log 1, "./#{@answers.baseFolder}/#{@answers.name}"
      console.log 2, @answers
      console.log 3, @answers.name
      @fs.copyTpl @templatePath('default/**/*'), @destinationPath("./#{@answers.baseFolder}/#{@answers.name}"), {c: @conf}


module.exports = GarlicWebappNg2ServiceGenerator
