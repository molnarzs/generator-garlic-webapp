util = require('util')
path = require('path')
yeoman = require('yeoman-generator')
chalk = require('chalk')
_ = require 'lodash'
generatorLib = require '../lib'

GarlicWebappGithubGenerator = yeoman.generators.Base.extend
  initializing:

    init: ->
      console.log chalk.magenta 'You\'re using the GarlicTech travis preparator.'
      generatorLib.createConfig.bind(@)()


  prompting: ->
    done = @async()
    @answers = {}
    cb = (answers) =>
      @answers = _.assign @answers, answers
      done()

    questions = [{
        type    : 'input'
        name    : 'githubToken'
        default : process.env.GITHUB_TOKEN
        message : "Enter the github personal token:"
        store   : true
      }, {
        type    : 'input'
        name    : 'githubUser'
        default : process.env.GITHUB_USER
        message : "Enter the github user:"
        store   : true
      }
    ]

    if @options.answers?.dockerUser?
      @answers.dockerUser = @options.answers.dockerUser
    else
      questions.push
        type    : 'input'
        name    : 'dockerUser'
        default : process.env.DOCKER_USER
        message : "Docker private repo username: (we take the default from the environment variable DOCKER_USER):"
        store   : true

    if @options.answers?.dockerPassword?
      @answers.dockerPassword = @options.answers.dockerPassword
    else
      questions.push
        type    : 'input'
        name    : 'dockerPassword'
        default : process.env.DOCKER_PASSWORD
        message : "Docker private repo password: (we take the default from the environment variable DOCKER_PASSWORD):"
        store   : true

    @prompt questions, cb.bind @

  writing:
    createConfig: ->
      done = @async()
      @conf.dockerUser = @answers.dockerUser
      @conf.dockerPassword = @answers.dockerPassword
      @conf.githubToken = @answers.githubToken
      @conf.githubUser = @answers.githubUser
      done()


    mainFiles: ->
      @fs.copyTpl @templatePath('default/**/*'), @destinationPath("./"), {c: @conf}
      @fs.copyTpl


  end:
    executeScript: ->
      done = @async()
      generatorLib.execute ". ./travis_config.sh"
      generatorLib.execute "rm ./travis_config.sh"
      done()


module.exports = GarlicWebappGithubGenerator
