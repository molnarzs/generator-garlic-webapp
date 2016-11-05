util = require('util')
path = require('path')
yeoman = require('yeoman-generator')
chalk = require('chalk')
spawn = require('child_process').spawn
_ = require 'lodash'
fs = require 'fs'

GarlicWebappBCompGenerator = yeoman.generators.Base.extend
  initializing:
    init: ->
      @conf = @config.getAll()
      console.log chalk.magenta 'You\'re using the GarlicTech webapp background component service.'
      @serverComponents = @conf.server

  prompting: ->
    done = @async()
    cb = (answers) =>
      @answers = answers
      @conf.componentNameCC = _.upperFirst _.camelCase @answers.name
      @conf.componentName = @answers.name
      @serverComponents.components.push @conf.componentName
      done()

    @prompt [{
        type    : 'input'
        name    : 'name'
        message : 'Component name (like foo-component): '
        required: true
      }, {
        type    : 'input'
        name    : 'serverPath'
        default : 'server'
        store   : 'true'
        message : 'Component name (like foo-component): '
        required: true
    }], cb.bind @

  writing:
    mainFiles: ->
      @fs.copyTpl @templatePath('default/**/*'), @destinationPath("./#{@answers.serverPath}/#{@conf.componentName}"), {c: @conf}

    saveConfig: ->
      @config.set 'server', @serverComponents

module.exports = GarlicWebappBCompGenerator
