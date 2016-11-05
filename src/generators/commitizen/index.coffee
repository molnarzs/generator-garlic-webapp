util = require('util')
path = require('path')
yeoman = require('yeoman-generator')
chalk = require('chalk')
jsonfile = require 'jsonfile'
_ = require 'lodash'
fs = require 'fs'
generatorLib = require '../lib'

GarlicWebappGithubGenerator = yeoman.generators.Base.extend
  initializing:

    init: ->
      console.log chalk.magenta 'You\'re using the GarlicTech webapp / commitizen generator.'
      generatorLib.createConfig.bind(@)()



  prompting: ->
    done = @async()
    @answers = {}
    cb = (answers) =>
      @answers = _.assign @answers, answers
      done()

    if @options.answers?.dockerRepo?
      @answers.dockerRepo = @options.answers.dockerRepo
      done()
    else
      @prompt [{
        type    : 'input'
        name    : 'dockerRepo'
        default : "docker.#{@conf.scope}.com"
        message : 'Docker repo:'
        store   : true
      }], cb.bind @


  writing:
    mainFiles: ->
      dest = "./"
      @conf.dockerRepo = @answers.dockerRepo
      @fs.copyTpl @templatePath('default/**/*'), @destinationPath(dest), {c: @conf}


    "package.json": ->
      cb = @async()
      pjson = jsonfile.readFileSync @destinationPath("./package.json")
      _.set pjson, 'config.commitizen.path', "/app/node_modules/cz-conventional-changelog"
      _.set pjson, "scripts.commit", "docker/commit.sh"
      jsonfile.spaces = 2
      jsonfile.writeFileSync @destinationPath("./package.json"), pjson
      cb()


    "README.md": ->
      cb = @async()
      fileName = @destinationPath "./README.md"
      content = fs.readFileSync fileName, {encoding: 'utf8'}
      content = _.split content, '\n'
      content.splice 2, 0, "[![Commitizen friendly](https://img.shields.io/badge/commitizen-friendly-brightgreen.svg)](http://commitizen.github.io/cz-cli/)"
      content = _.join content, '\n'
      fs.writeFileSync fileName, content
      cb()



module.exports = GarlicWebappGithubGenerator
