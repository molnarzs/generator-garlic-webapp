util = require('util')
path = require('path')
yeoman = require('yeoman-generator')
chalk = require('chalk')
jsonfile = require 'jsonfile'
_ = require 'lodash'
yaml = require 'node-yaml'
fs = require 'fs'
generatorLib = require '../lib'

GarlicWebappGithubGenerator = yeoman.generators.Base.extend
  initializing:

    init: ->
      console.log chalk.magenta 'You\'re using the GarlicTech webapp / semantic releasing generator.'
      generatorLib.createConfig.bind(@)()


  prompting: ->
    done = @async()
    console.log 2,  @options

    if @options?.answers?.dockerRepo?
      @conf.dockerRepo = @options.answers.dockerRepo
      done()
    else
      cb = (answers) =>
        @conf.dockerRepo = answers.dockerRepo
        done()

      dockerRepo = "docker.#{@conf.scope}.com"

      @prompt [{
          type    : 'input'
          name    : 'dockerRepo'
          default : dockerRepo
          message : 'Docker repo:'
          store   : true
        }
      ], cb.bind @


  writing:
    mainFiles: ->
      cb = @async()
      @fs.copyTpl @templatePath('default/**/*'), @destinationPath("./"), {c: @conf}
      cb()


    "package.json": ->
      cb = @async()
      pjson = jsonfile.readFileSync @destinationPath("./package.json")
      _.set pjson, "scripts.semantic-release", "docker/semantic-release.sh"
      jsonfile.spaces = 2
      jsonfile.writeFileSync @destinationPath("./package.json"), pjson
      cb()


    ".travis.yml": ->
      cb = @async()
      file = @destinationPath "./.travis.yml"
      data = yaml.readSync file
      if not data.after_success then data.after_success = []

      if (not data.after_success[0]?) or "npm run semantic-release" not in data.after_success[0]
        data.after_success.unshift "[ \"${TRAVIS_PULL_REQUEST}\" = \"false\" ] && npm run semantic-release"

      yaml.writeSync file, data
      cb()

    "README.md": ->
      cb = @async()
      fileName = @destinationPath "./README.md"
      content = fs.readFileSync fileName, {encoding: 'utf8'}
      content = _.split content, '\n'
      content.splice 2, 0, "[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)"
      content = _.join content, '\n'
      fs.writeFileSync fileName, content
      cb()


module.exports = GarlicWebappGithubGenerator
