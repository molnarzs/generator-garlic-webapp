_ = require 'lodash'
execute = require('child_process').execSync


Methods =
  createConfig: ->
    conf = @config.getAll()
    scopecC = _.camelCase conf.scope
    scopeCC = _.upperFirst scopecC
    appNameAsIs = "#{conf.appname}"
    appNameKC = _.kebabCase(conf.appname).replace('ng-x', 'ngx')
    appNameFQ = _.kebabCase appNameAsIs
    appNameFQcC = _.camelCase appNameFQ

    @conf = _.assign conf,
      scope: conf.scope # foo-bar
      scopecC: scopecC # fooBar
      scopeCC: scopeCC # FooBar
      appNameKC: appNameKC # my-app
      appNameAsIs: appNameAsIs # my app
      appNameFQ: appNameFQ # my-app
      appNameFQcC: appNameFQcC
      appNameFQCC: _.upperFirst appNameFQcC
      npmToken: process.env["NPM_TOKEN_#{scopeCC}"]
      slackToken: process.env["SLACK_TOKEN_#{scopeCC}"]


  createDirectiveConfig: ->
    Methods.createConfig.bind(@)()
    if @options.view then @answers = @options.answers
    @conf.componentNameCC = _.upperFirst _.camelCase @answers.name
    @conf.moduleName = "#{@conf.angularModuleName}.#{@conf.componentNameCC}"
    @conf.directiveNameCC = "#{@conf.scopecC}#{@conf.appNameFQCC}#{@conf.componentNameCC}"
    @conf.directiveNameKC = "#{@conf.scope}-#{@conf.appNameFQ}-#{@answers.name}"

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


  execute: (command) ->
    execute command, {stdio:[0,1,2]}


  pushToQuestions: (questions, property, type, deflt, message, store) ->
    if @options.answers?[property]?
      @answers[property] = @options.answers[property]
      return null
    else
      questions.push
        type    : type
        name    : property
        default : deflt
        message : message
        store   : store


module.exports = Methods
