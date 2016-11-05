util = require('util')
path = require('path')
yeoman = require('yeoman-generator')
chalk = require('chalk')
_ = require 'lodash'
generatorLib = require '../lib'

GarlicWebappGithubGenerator = yeoman.generators.Base.extend
  initializing:

    init: ->
      console.log chalk.magenta 'You\'re using the GarlicTech travis config generator.'
      generatorLib.createConfig.bind(@)()


  prompting: ->
    done = @async()
    @answers = {}
    cb = (answers) =>
      @answers = _.assign @answers, answers
      done()

    questions = [{
        type    : 'input'
        name    : 'dockerMachine'
        default : ""
        message : "Enter the SSH access of the docker machine this repo uses. Keep it empty if the project does not use docker docker machine. Example: root@api.gtrack.events"
        store   : true
      }
    ]

    if @options.answers?.slackToken?
      @answers.slackToken = @options.answers.slackToken
    else
      questions.push
        type    : 'input'
        name    : process.env["SLACK_TOKEN_#{@conf.scopeCC}"]
        default : slackToken
        message : "Slack token: (we take the default from the environment variable SLACK_TOKEN_#{@conf.scopeCC}):"
        store   : true


    if @options.answers?.dockerRepo?
      @answers.dockerRepo = @options.answers.dockerRepo
    else
      questions.push
        type    : 'input'
        name    : 'dockerRepo'
        default : "docker.#{@conf.scope}.com"
        message : 'Docker repo:'
        store   : true


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
      @conf.slackToken = @answers.slackToken
      @conf.dockerMachine = @answers.dockerMachine
      @conf.dockerRepo = @answers.dockerRepo
      done()


    mainFiles: ->
      @fs.copyTpl @templatePath('default/**/*'), @destinationPath("./"), {c: @conf}
      @fs.copyTpl @templatePath('dotfiles/_travis.yml'), @destinationPath("./.travis.yml"), {c: @conf}


  end:
    executeScript: ->
      done = @async()
      generatorLib.execute ". ./travis_config.sh"
      generatorLib.execute "rm ./travis_config.sh"
      done()


module.exports = GarlicWebappGithubGenerator
