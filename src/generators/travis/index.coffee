util = require('util')
path = require('path')
yeoman = require('yeoman-generator')
chalk = require('chalk')
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
      @answers = answers
      done()

    slackToken = process.env["SLACK_TOKEN_#{@conf.scopeCC}"]
    dockerUser = process.env.DOCKER_USER
    dockerPassword = process.env.DOCKER_PASSWORD

    questions = [{
        type    : 'input'
        name    : 'slackToken'
        default : slackToken
        message : "Slack token: (we take the default from the environment variable SLACK_TOKEN_#{@conf.scopeCC}):"
        store   : true
      }, {
        type    : 'input'
        name    : 'dockerUser'
        default : dockerUser
        message : "Docker private repo username: (we take the default from the environment variable DOCKER_USER):"
        store   : true
      }, {
        type    : 'input'
        name    : 'dockerPassword'
        default : dockerPassword
        message : "Docker private repo password: (we take the default from the environment variable DOCKER_PASSWORD):"
        store   : true
      }, {
        type    : 'input'
        name    : 'dockerMachine'
        default : ""
        message : "Enter the SSH access of the docker machine this repo uses. Keep it empty if the project does not use docker docker machine. Example: root@api.gtrack.events"
        store   : true
      }
    ]

    if @options.answers?.dockerRepo?
      @answers.dockerRepo = @options.answers.dockerRepo
    else
      questions.push
        type    : 'input'
        name    : 'dockerRepo'
        default : "docker.#{@conf.scope}.com"
        message : 'Docker repo:'
        store   : true

    @prompt questions, cb.bind @
 
  writing:
    createConfig: ->
      done = @async()
      @conf.dockerUser = @answers.dockerUser
      @conf.dockerPassword = @answers.dockerPassword
      @conf.slackToken = @answers.slackToken
      @conf.dockerMachine = @answers.dockerMachine
      done()


    mainFiles: ->
      @fs.copyTpl @templatePath('default/**/*'), @destinationPath("./"), {c: @conf}


  end:
    executeScript: ->
      done = @async()
      generatorLib.execute ". ./travis_config.sh"
      done()


module.exports = GarlicWebappGithubGenerator
