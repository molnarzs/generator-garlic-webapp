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

    questions = []
    generatorLib.pushToQuestions.bind(@) questions, 'dockerMachine', 'input', "",
      "Enter the SSH access of the docker machine this repo uses. Keep it empty if the project does not use docker docker machine. Example: root@api.gtrack.events",
      true

    generatorLib.pushToQuestions.bind(@) questions, 'slackToken', 'input', process.env["SLACK_TOKEN_#{@conf.scopeCC}"],
      "Slack token: (we take the default from the environment variable SLACK_TOKEN_#{@conf.scopeCC}):"
      true

    generatorLib.pushToQuestions.bind(@) questions, 'dockerRepo', 'input', "docker.#{@conf.scope}.com",
      'Docker repo:'
      true

    generatorLib.pushToQuestions.bind(@) questions, 'dockerUser', 'input', process.env.DOCKER_USER,
      "Docker private repo username: (we take the default from the environment variable DOCKER_USER):"
      true

    generatorLib.pushToQuestions.bind(@) questions, 'dockerPassword', 'input', process.env.DOCKER_PASSWORD,
      "Docker private repo password: (we take the default from the environment variable DOCKER_PASSWORD):"
      true

    generatorLib.pushToQuestions.bind(@) questions, 'githubUser', 'input', process.env.GITHUB_USER,
      "Enter the github user:"
      true

    generatorLib.pushToQuestions.bind(@) questions, 'githubToken', 'input', process.env.GITHUB_TOKEN,
      "Enter the github personal token:"
      true

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
    travisPrepare: ->
      done = @async()
      @composeWith 'garlic-webapp:travis-prepare', options: {answers: @answers}
      done()


    executeScript: ->
      done = @async()
      generatorLib.execute ". ./travis_config.sh"
      generatorLib.execute "rm ./travis_config.sh"
      done()

module.exports = GarlicWebappGithubGenerator
