util = require('util')
path = require('path')
yeoman = require('yeoman-generator')
chalk = require('chalk')
_ = require 'lodash'
mkdirp = require 'mkdirp'
execute = require('child_process').execSync

GarlicWebappGenerator = yeoman.generators.Base.extend
  initializing:

    init: ->
      @config.set
        appname: @appname
        angularModules:
          directives: []
          services: []
          factories: []
          pages: []
          providers: []
        server:
          components: []
        common:
          components: []
      console.log chalk.magenta 'You\'re using the GarlicTech webapp generator.'
      @conf = @config.getAll()

  prompting: ->
    done = @async()
    cb = (answers) =>
      @answers = answers
      done()

    @prompt [{
      type    : 'input',
      name    : 'scope',
      default : 'garlictech',
      message : 'Project scope (company github team):'
    }]
    , cb.bind @
 
  writing:
    createConfig: ->
      scopeCC = _.capitalize _.camelCase @answers.scope
      appNameAsIs = "#{scopeCC} #{@appname}"
      appNameKC = _.kebabCase @appname
      appNameFQ = _.kebabCase appNameAsIs
      appNameFQcC = _.camelCase appNameFQ
      angularModuleName = "#{scopeCC}/#{_.capitalize _.camelCase @appname}"

      console.log "EN", process.env["NPM_TOKEN_#{scopeCC}"], "NPM_TOKEN_#{scopeCC}"
      @config.set
        scope: @answers.scope
        scopeCC: scopeCC
        appNameKC: appNameKC
        appNameAsIs: appNameAsIs
        appNameFQ: appNameFQ
        appNameFQcC: appNameFQcC
        appNameFQCC: _.capitalize appNameFQcC
        angularModuleName: angularModuleName
        npmToken: process.env["NPM_TOKEN_#{scopeCC}"]
        slackToken: process.env["SLACK_TOKEN_#{scopeCC}"]

  
    mainFiles: ->
      cb = @async()
      @conf = @config.getAll()
      console.log 'C2', @conf

      @fs.copyTpl @templatePath('default/**/*'), @destinationPath("./"),
        conf: @conf

      @fs.copyTpl @templatePath('dotfiles/_travis.yml'), @destinationPath("./.travis.yml"),
        conf: @conf
      
      @fs.copy @templatePath('default_assets/**/*'), @destinationPath("./src/")
      cb()


    "src/directive-modules.coffee" : ->
      dest = @destinationPath "./src/directive-modules.coffee"

      if not @fs.exists dest
        @fs.write dest, """
Module = angular.module "#{@conf.angularModuleName}/Directives", []
module.exports = Module.name
"""


    "src/service-modules.coffee" : ->
      dest = @destinationPath "./src/service-modules.coffee"

      if not @fs.exists dest
        @fs.write dest, """
Module = angular.module "#{@conf.angularModuleName}/Services", []
module.exports = Module.name
"""


    "src/factory-modules.coffee" : ->
      dest = @destinationPath "./src/factory-modules.coffee"

      if not @fs.exists dest
        @fs.write dest, """
Module = angular.module "#{@conf.angularModuleName}/Factories", []
module.exports = Module.name
"""

    "src/provider-modules.coffee" : ->
      dest = @destinationPath "./src/provider-modules.coffee"

      if not @fs.exists dest
        @fs.write dest, """
Module = angular.module "#{@conf.angularModuleName}/Providers", []
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

module.exports = GarlicWebappGenerator
