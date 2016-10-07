util = require('util')
path = require('path')
yeoman = require('yeoman-generator')
chalk = require('chalk')
jsonfile = require 'jsonfile'
_ = require 'lodash'
generatorLib = require '../lib'

GarlicWebappGithubGenerator = yeoman.generators.Base.extend
  initializing:

    init: ->
      console.log chalk.magenta 'You\'re using the GarlicTech webapp / commitizen generator.'
      generatorLib.createConfig.bind(@)()


  writing:
    mainFiles: ->
      dest = "./"
      @fs.copyTpl @templatePath('default/**/*'), @destinationPath(dest), {c: @conf}


    "package.json": ->
      cb = @async()
      pjson = jsonfile.readFileSync @destinationPath("./package.json")
      _.set pjson, 'config.commitizen.path', "/app/node_modules/cz-conventional-changelog"
      _.set pjson, "scripts.commit", "docker/commit.sh"
      jsonfile.spaces = 2
      jsonfile.writeFileSync @destinationPath("./package.json"), pjson
      cb()


module.exports = GarlicWebappGithubGenerator
