util = require('util')
path = require('path')
yeoman = require('yeoman-generator')
chalk = require('chalk')
_ = require 'lodash'
mkdirp = require 'mkdirp'
execute = require('child_process').execSync

GarlicWebappClientGenerator = yeoman.generators.Base.extend
  initializing:

    init: ->
      @config.set
        appName: @appname
        angularModules:
          ui: []
          services: []
          factories: []
          pages: []
          providers: []
        server:
          components: []
        common:
          components: []
      console.log chalk.magenta 'You\'re using the GarlicTech webapp generator.'

  writing:
    mainFiles: ->
      cb = @async()
      @conf = @config.getAll()
      @fs.copyTpl @templatePath('default/**/*'), @destinationPath("./"),
        appName: _.kebabCase @conf.appName
        appNameCC: _.capitalize _.camelCase @conf.appName
        appNameAsIs: @conf.appName
      
      @fs.copy @templatePath('default_assets/**/*'), @destinationPath("./src/")
      cb()


    "src/ui-modules.coffee" : ->
      dest = @destinationPath "./src/ui-modules.coffee"

      if not @fs.exists dest
        @fs.write dest, """
Module = angular.module "#{@conf.appName}-ui", []
module.exports = Module.name
"""


    "src/service-modules.coffee" : ->
      dest = @destinationPath "./src/service-modules.coffee"

      if not @fs.exists dest
        @fs.write dest, """
Module = angular.module "#{@conf.appName}-services", []
module.exports = Module.name
"""


    "src/factory-modules.coffee" : ->
      dest = @destinationPath "./src/factory-modules.coffee"

      if not @fs.exists dest
        @fs.write dest, """
Module = angular.module "#{@conf.appName}-factories", []
module.exports = Module.name
"""

    "src/views/test-page/test-page-components.jade" : ->
      dest = @destinationPath "./src/views/test-page/test-page-components.jade"
      if not @fs.exists dest then @fs.write dest, ""


    dotfiles: ->
      @fs.copy @templatePath('default/.*'), @destinationPath("./")

  install:
    dependencies: ->
      cb = @async()
      # console.log "\nLinking @garlictech/complib.\n"
      # @spawnCommand 'npm', ['link', '@garlictech/complib']
      if not @options['skip-install'] then @installDependencies()
      cb()

    # createLocalGitRepo: ->
    #   done = @async()
    #   repoRoot = process.env.GIT_REPOS_ROOT
    #   if not repoRoot
    #     console.log "Git repo creation skipped (no GIT_REPOS_ROOT env. variable set)"
    #   else if @options['skip-install']
    #     console.log "Git repo creation skipped"
    #   else
    #     console.log "Creating local git repo to #{repoRoot}"
    #     pwd = process.cwd()
    #     repoName = "#{@conf.appName}.git"
    #     process.chdir repoRoot
    #     mkdirp.sync repoName
    #     process.chdir repoName
    #     execute "git init --bare"
    #     process.chdir pwd
    #     execute "git init"
    #     execute "git remote add origin #{repoRoot}/#{repoName}"
    #     execute "git add ."
    #     execute "git commit -m 'Initial version.'"
    #     execute 'git push -u origin master'
    #     done()

  # runRemoteGit: ->
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

module.exports = GarlicWebappClientGenerator
