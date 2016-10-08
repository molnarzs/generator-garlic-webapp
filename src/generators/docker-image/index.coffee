util = require('util')
path = require('path')
yeoman = require('yeoman-generator')
chalk = require('chalk')
_ = require 'lodash'
generatorLib = require '../lib'

GarlicWebappGithubGenerator = yeoman.generators.Base.extend
  initializing:

    init: ->
      console.log chalk.magenta 'You\'re using the GarlicTech webapp / docker image generator.'
      generatorLib.createConfig.bind(@)()


  prompting: ->
    done = @async()
    cb = (answers) =>
      @answers = answers
      done()

    @prompt
      type    : 'input'
      name    : 'name'
      message : 'Docker image name (like foo-image): '
      required: true
    , cb.bind @
 
  writing:
    createConfig: ->
      @conf.imageName = @answers.name

    mainFiles: ->
      dest = "./docker-images/#{@answers.name}"

      @fs.copyTpl @templatePath('default/image/**/*'), @destinationPath(dest), {c: @conf}
      @fs.copyTpl @templatePath('dotfiles/_dockerignore'), @destinationPath("#{dest}/.dockerignore"), {c: @conf}
      @fs.copyTpl @templatePath('default/scripts/**/*'), @destinationPath('./docker-images/scripts'), {c: @conf}

module.exports = GarlicWebappGithubGenerator
