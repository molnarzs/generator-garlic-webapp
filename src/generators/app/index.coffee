util = require('util')
path = require('path')
yeoman = require('yeoman-generator')
chalk = require('chalk')
spawn = require('child_process').spawn
# sh = require('execSync')

execute = (command) ->
  result = sh.exec command
  console.log result.stdout

GarlicWebappGenerator = yeoman.generators.Base.extend
  initializing:
    init: ->
      @config.set
        appName: @appname
      console.log chalk.magenta 'You\'re using the GarlicTech webapp generator.'

  writing:
    mainFiles: ->
      @config = @config.getAll()
      @fs.copyTpl @templatePath('default/**/*'), @destinationPath("./"),
        appName: @config.appName
      
      @fs.copy @templatePath('default_assets/**/*'), @destinationPath("./frontend/src/")

  install:
    linkGtComplib: ->
      if not @options['skip-install']
        console.log "\nLinking gt-complib.\n"
        @spawnCommand 'npm', ['link', 'gt-complib']

    dependencies: ->
      if not @options['skip-install'] then @installDependencies()

  # runBower: ->
  #   if not @options['skip-install']
  #     done = @async()
  #     console.log("\nRunning Bower:\n")
  #     @bowerInstall "", ->
  #       console.log("\nAll set! Type: gulp serve\n")
  #       done()

  # runGit: ->
  #   done = @async()

  #   if not @githubAuthtoken
  #     console.log "\nWarning: Github repo not created: github oauth token is unknown or invalid.\n"
  #     return

  #   console.log "\nCreating GitHub repo...\n"
  #   execute "curl https://api.github.com/orgs/garlictech/repos -u #{@githubAuthtoken}:x-oauth-basic -d \'{\"name\":\"#{@appname}\"}\'"
  #   execute "git init"
  #   execute "git remote add origin https://github.com/garlictech/#{@appname}.git"
  #   execute "git add ."
  #   execute "git commit -m 'Initial version.'"
  #   execute 'git push -u origin master'
  #   done()

module.exports = GarlicWebappGenerator
