util = require('util')
path = require('path')
yeoman = require('yeoman-generator')
chalk = require('chalk')
execute = require('child_process').execSync

GarlicWebappGenerator = yeoman.generators.Base.extend
  initializing:

    init: ->
      console.log chalk.magenta 'You\'re using the GarlicTech webapp generator.'
      @conf = @config.getAll()

  prompting: ->
    done = @async()
    cb = (answers) =>
      @answers = answers
      done()

    defaultToken = process.env.GITHUB_TOKEN
    console.log 'X', defaultToken

    @prompt [{
      type    : 'input',
      name    : 'repo',
      default : 'garlictech'
      message : 'Github repo:'
      store   : true
    }, {
      type    : 'input'
      name    : 'githubToken'
      default : defaultToken
      message : 'Github token:'
      store   : true
    }]
    , cb.bind @
 
  writing:
    runRemoteGit: ->
      done = @async()

      if not @answers.githubToken?
        console.log "\nWarning: Github repo not created: github oauth token is unknown or invalid.\n"
        return

      console.log "\nCreating GitHub repo...\n"
      execute "curl https://api.github.com/orgs/#{@conf.scope}/repos -u #{@answers.githubToken}:x-oauth-basic -d \'{\"name\":\"#{@conf.appNameKC}\"}\'"
      execute "git init"
      execute "git remote add origin https://github.com/#{@conf.scope}/#{@conf.appNameKC}.git"
      execute "git add ."
      execute "git commit -m 'Initial version.'"
      execute 'git push -u origin master'
      done()

module.exports = GarlicWebappGenerator
