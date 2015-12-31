util = require('util')
path = require('path')
generators = require('yeoman-generator')
chalk = require('chalk')
spawn = require('child_process').spawn
# sh = require('execSync')

execute = (command) ->
  result = sh.exec command
  console.log result.stdout

module.exports = generators.Base.extend
  constructor: ->
    generators.Base.apply @, arguments
    @option "name"

  copyFiles: ->
    # @githubAuthtoken = @arguments[0]
    # # read the local package file

    # @pkg = yeoman.file.readJSON path.join __dirname, '../package.json'
    # @config.set
    #   appName: @appname
    #   css: ['bootstrap'],
    #   scaffolds:['']
    # # have Yeoman greet the user
    # console.log @yeoman
    # replace it with a short and sweet description of your generator
    console.log chalk.magenta 'You\'re using the GarlicTech webapp generator for Angular UI element.'

  saveConfig: ->
    @config.save()

  # scaffoldFolders: ->
  #   @mkdir("./frontend")
  #   @mkdir("./frontend/modules")
  #   @mkdir("./frontend/resources")
  #   @mkdir("./frontend/styles")
  #   @mkdir("./backend/config")
  #   @mkdir("./backend/config/env")
  #   @mkdir("./backend/modules")
  #   @mkdir("./features")
  #   @mkdir("./features/step_definitions")
  #   @mkdir("./features/support")
  #   @mkdir("./logs")

  # copyMainFiles: ->
  #   @config = @config.getAll()
  #   @directory("./default", "./")

  # runNpm: ->
  #   if not @options['skip-install']
  #     done = @async()
  #     console.log("\nRunning NPM Install. Bower is next.\n")
  #     seleniumLogdir = path.join(@destinationRoot(), 'node_modules', 'selenium-server', 'logs')
  #     seleniumLogdirLink = path.join(@destinationRoot(), 'logs', 'selenium')

  #     @npmInstall "", ->
  #       spawn 'ln', ['-sf', seleniumLogdir, seleniumLogdirLink], stdio:'inherit'
  #       done()

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
