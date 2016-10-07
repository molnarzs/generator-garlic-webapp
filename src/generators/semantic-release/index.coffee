util = require('util')
path = require('path')
yeoman = require('yeoman-generator')
chalk = require('chalk')
jsonfile = require 'jsonfile'
_ = require 'lodash'
yaml = require 'node-yaml'
generatorLib = require '../lib'

GarlicWebappGithubGenerator = yeoman.generators.Base.extend
  initializing:

    init: ->
      console.log chalk.magenta 'You\'re using the GarlicTech webapp / semantic releasing generator.'
      generatorLib.createConfig.bind(@)()


  writing:
    "package.json": ->
      cb = @async()
      pjson = jsonfile.readFileSync @destinationPath("./package.json")
      _.set pjson, "scripts.semantic-release", "semantic-release pre && npm publish && semantic-release post"
      pjson.version = "0.0.0-semantically-released"
      jsonfile.spaces = 2
      jsonfile.writeFileSync @destinationPath("./package.json"), pjson
      cb()


    ".travis.yml": ->
      cb = @async()
      file = @destinationPath "./.travis.yml"
      data = yaml.readSync file
      if not data.after_success then data.after_success = []

      if (not data.after_success[0]?) or "npm run semantic-release" not in data.after_success[0]
        data.after_success.unshift "npm run semantic-release"

      _.set data, "cache.directories", "node_modules"
      yaml.writeSync file, data
      cb()

module.exports = GarlicWebappGithubGenerator
