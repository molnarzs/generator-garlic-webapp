_ = require 'lodash'

Methods =
  createConfig: ->
    conf = @config.getAll()
    scopeCC = _.capitalize _.camelCase conf.scope
    appNameAsIs = "#{scopeCC} #{conf.appname}"
    appNameKC = _.kebabCase conf.appname
    appNameFQ = _.kebabCase appNameAsIs
    appNameFQcC = _.camelCase appNameFQ

    @conf = _.assign conf,
      scope: conf.scope
      scopeCC: scopeCC
      appNameKC: appNameKC
      appNameAsIs: appNameAsIs
      appNameFQ: appNameFQ
      appNameFQcC: appNameFQcC
      appNameFQCC: _.capitalize appNameFQcC
      npmToken: process.env["NPM_TOKEN_#{scopeCC}"]
      slackToken: process.env["SLACK_TOKEN_#{scopeCC}"]


  createDirectiveConfig: ->
    Methods.createConfig.bind(@)()
    if @options.view then @answers = @options.answers
    @conf.componentNameCC = _.capitalize _.camelCase @answers.name
    @conf.moduleName = "#{@conf.angularModuleName}.#{@conf.componentNameCC}"
    @conf.directiveNameCC = "#{@conf.appNameFQcC}#{@conf.componentNameCC}"
    @conf.directiveNameKC = "#{@conf.appNameFQ}-#{@answers.name}"

    if @options.view
      @conf.moduleName = "#{@conf.moduleName}.View"
      @conf.directiveNameCC = "#{@conf.directiveNameCC}View"
      @conf.directiveNameKC = "#{@conf.directiveNameKC}-view"
      @moduleNames = @conf.angularModules.views
    else
      @moduleNames = @conf.angularModules.directives

    @moduleNames.push @answers.name


  prompting: ->
    done = @async()
    cb = (answers) =>
      @answers = answers
      @config.set {scope: @answers.scope}
      done()

    @prompt [{
      type    : 'input',
      name    : 'scope',
      default : 'garlictech',
      message : 'Project scope (company github team):'
    }]
    , cb.bind @


  dependencies: ->
    cb = @async()
    if not @options['skip-install'] then @installDependencies()
    cb()

module.exports = Methods
