util = require('util')
path = require('path')
yeoman = require('yeoman-generator')
chalk = require('chalk')
mkdirp = require 'mkdirp'
execute = require('child_process').execSync
jsonfile = require 'jsonfile'
generatorLib = require '../lib'

GarlicWebappGenerator = yeoman.generators.Base.extend
  initializing: ->
    console.log chalk.magenta 'You\'re using the GarlicTech webapp generator.'
    @composeWith 'loopback', {options: {"skip-install": true}}


  prompting: ->
    generatorLib.prompting.bind(@)()

 
  writing:
    createConfig: ->
      generatorLib.createConfig.bind(@)()

  
    mainFiles: ->
      cb = @async()
      @conf = @config.getAll()

      @fs.copyTpl @templatePath('default/**/*'), @destinationPath("./"),
        conf: @conf

      @fs.copyTpl @templatePath('dotfiles/_travis.yml'), @destinationPath("./.travis.yml"),
        conf: @conf
      
      cb()


    "package.json": ->
      cb = @async()
      @conf = @config.getAll()
      pjson = jsonfile.readFileSync @destinationPath("./package.json")
      pjson.name = "@#{@conf.scope}/#{@conf.appNameKC}"
      pjson.version = "0.0.1"
      pjson.description = "#{@conf.appNameAsIs}"
      pjson.main = "dist/server.js"
      pjson.license = "SEE LICENSE IN license.txt"
      pjson.repository =
        "type": "git"
        "url": "https://github.com/#{@conf.scope}/#{@conf.appNameKC}.git"
  
      pjson.author =
        "name": "#{@conf.scopeCC}",
        "email": "contact@#{@conf.scope}.com",
        "url": "http://www.#{@conf.scope}.com"
      pjson.contributors = [
        "Zsolt R. Molnar <zsolt@zsoltmolnar.hu> (http://www.zsoltmolnar.hu)"
      ]

      pjson.keywords = [
        "#{@conf.appName}",
        "#{@conf.appNameKC}",
        "#{@conf.scope}"
      ]

      pjson.bugs =
        "url": "https://github.com/#{@conf.scope}/#{@conf.appNameKC}/issues"
      
      pjson.homepage = "https://github.com/#{@conf.scope}/#{@conf.appNameKC}/wiki/Home"
      
      pjson.devDependencies =
        "garlictech-workflows-server": "^0.1"

      pjson.dependencies["garlictech-common-server"] = "^0.0"

      pjson.engines =
        "npm" : ">=3.0.0",
        "node": ">=5.0.0"

      pjson.scripts =
        "build": "gulp build",
        "start": "node .",
        "start-dev": "gulp",
        "debug": "node --debug-brk dist/server.js",
        "unittest": "scripts/unittest.sh",
        "systemtest": "scripts/systemtest.sh",
        "setup-dev": "scripts/setup-dev.sh",
        "test": "npm run unittest && npm run systemtest",
        "posttest": "nsp check"

      
      pjson.garlic =
        "unittest": "./dist/test/unit/index.js"
    
      pjson.config =
        "port": 3000

      jsonfile.spaces = 2
      jsonfile.writeFileSync @destinationPath("./package.json"), pjson
      cb()


    dotfiles: ->
      @fs.copy @templatePath('default/.*'), @destinationPath("./")

  install:
    dependencies: ->
      generatorLib.dependencies.bind(@)()

module.exports = GarlicWebappGenerator
