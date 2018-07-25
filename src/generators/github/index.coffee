util = require('util')
path = require('path')
yeoman = require('yeoman-generator')
chalk = require('chalk')
generatorLib = require '../lib'

GarlicWebappGithubGenerator = yeoman.generators.Base.extend
  initializing:

    init: ->
      console.log chalk.magenta 'You\'re using the GarlicTech github repo generator.'
      generatorLib.createConfig.bind(@)()


  prompting: ->
    done = @async()
    cb = (answers) =>
      @answers = answers
      done()

    githubToken = process.env.GITHUB_TOKEN
    npmToken = process.env["NPM_TOKEN_#{@conf.scopeCC}"]
    slackToken = process.env["SLACK_TOKEN_#{@conf.scopeCC}"]
    slackWebhookUrl = process.env["SLACK_WEBHOOK_URL_#{@conf.scopeCC}"]
    devTeamId = process.env["DEV_TEAM_ID_#{@conf.scopeCC}"]
    dockerUser = process.env.DOCKER_USER
    dockerPassword = process.env.DOCKER_PASSWORD

    @prompt [{
        type    : 'input'
        name    : 'githubToken'
        default : githubToken
        message : 'Github token (we take the default from the environment variable GITHUB_TOKEN):'
        store   : true
      }, {
        type    : 'input'
        name    : 'slackToken'
        default : slackToken
        message : "Slack token: (we take the default from the environment variable SLACK_TOKEN_#{@conf.scopeCC}):"
        store   : true
      }, {
        type    : 'input'
        name    : 'slackWebhook'
        default : slackWebhookUrl
        message : "Slack webhook url: (we take the default from the environment variable SLACK_WEBHOOK_URL_#{@conf.scopeCC}):"
        store   : true
      }, {
        type    : 'input'
        name    : 'devTeam'
        default : devTeamId
        message : "Development team ID: (we take the default from the environment variable DEV_TEAM_ID_#{@conf.scopeCC}):"
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
        type    : 'confirm'
        name    : 'isPrivate'
        default : true
        message : "Private repo?"
        store   : true
      }
    ], cb.bind @

  writing:
    mainFiles: ->
      @fs.copyTpl @templatePath('default/**/*'), @destinationPath("./"), {c: @conf}
      @fs.copyTpl

    runRemoteGit: ->
      done = @async()
      console.log chalk.blue "\nCreating GitHub repo...\n"

      repoCreateCmd = "curl https://api.github.com/orgs/#{@conf.scope}/repos -u #{@answers.githubToken}:x-oauth-basic -d \'{\"name\":\"#{@conf.appNameKC}\", \"private\": #{@answers.isPrivate}, \"team_id\": #{@answers.devTeam}}\'"
      generatorLib.execute repoCreateCmd
      generatorLib.execute "git init"
      generatorLib.execute "git remote add origin https://github.com/#{@conf.scope}/#{@conf.appNameKC}.git"

      console.log chalk.blue "\Configuring webhooks...\n"
      webhook =
        name: "web"
        config:
          url: @answers.slackWebhook
          content_type: 'json'
        active: true
        events: ['issues', 'issue_comment', 'member', 'pull_request', 'pull_request_review_comment', 'deployment']

      webhookCreateCmd = "curl https://api.github.com/repos/#{@conf.scope}/#{@conf.appNameKC}/hooks -u #{@answers.githubToken}:x-oauth-basic -d \'#{JSON.stringify webhook}\'"
      generatorLib.execute webhookCreateCmd
      console.log chalk.blue "\nRepo is created. Nothing is committed yet!\n"
      done()

  end:
    executeLabelCreation: ->
      done = @async()
      generatorLib.execute ". ./github-prepare.sh"
      generatorLib.execute "rm ./github-prepare.sh"
      done()


module.exports = GarlicWebappGithubGenerator
