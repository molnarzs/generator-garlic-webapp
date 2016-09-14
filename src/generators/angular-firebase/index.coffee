yeoman = require('yeoman-generator')
chalk = require('chalk')
_ = require 'lodash'
fs = require 'fs'
generatorLib = require '../lib'

GarlicWebappAngularFirebaseGenerator = yeoman.generators.Base.extend
  initializing:
    init: ->
      @conf = @config.getAll()
      console.log chalk.magenta 'You\'re adding firebase to the angular app.'


  prompting: ->
    done = @async()
    cb = (answers) =>
      @answers = answers
      done()

    @prompt [{
        type    : 'input'
        name    : 'apiKey'
        message : 'API key: '
        required: true
      }, {
        type    : 'input'
        name    : 'authDomain'
        message : 'Auth domain: '
        required: true
      }, {
        type    : 'input'
        name    : 'databaseURL'
        message : 'Database URL: '
        required: true
      }, {
        type    : 'input'
        name    : 'storageBucket'
        message : 'Storage Bucket: '
        required: true
      }
    ], cb.bind @


  writing:
    createConfig: ->
      @conf.service = "firebase-service"
      @conf = _.assign @conf, generatorLib.createConfig.bind(@)()
      @moduleNames = @conf.angularModules.services
      @moduleNames.push @conf.service
      @conf.serviceName = _.capitalize _.camelCase @conf.service
      @conf.moduleName = "#{@conf.angularModuleName}.#{@conf.serviceName}"
      @conf.serviceNameFQ = @conf.moduleName
      @conf = _.assign @conf, @answers

    mainFiles: ->
      @fs.copyTpl @templatePath('default/**/*'), @destinationPath("./src/#{@conf.service}"), {c: @conf}


    "vendor/index.json": ->
      cb = @async()
      path = @destinationPath "./src/vendor/index.coffee"
      content = fs.readFileSync path, 'utf8'

      content = content + """
  require 'angularfire'\n
      """

      fs.writeFileSync path, content, 'utf8'
      cb()

    "service-modules.coffee": ->
      dest = @destinationPath("./src/service-modules.coffee")
      content = """Module = angular.module "#{@conf.angularModuleName}.Services", ["""

      _.forEach @moduleNames, (moduleName) ->
        content += "\n  require './#{moduleName}'"

      content += "\n]\n\nmodule.exports = Module.name"
      @fs.write dest, content


    saveConfig: ->
      @config.set 'angularModules', @conf.angularModules


  install:
    dependencies: ->
      @npmInstall ['firebase', 'angularfire'], { 'save': true }

module.exports = GarlicWebappAngularFirebaseGenerator
