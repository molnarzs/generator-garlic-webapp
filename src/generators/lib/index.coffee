_ = require 'lodash'

module.exports =
  createConfig: ->
    conf = @config.getAll()

    scopeCC = _.capitalize _.camelCase conf.scope
    appNameAsIs = "#{scopeCC} #{conf.appname}"
    appNameKC = _.kebabCase conf.appname
    appNameFQ = _.kebabCase appNameAsIs
    appNameFQcC = _.camelCase appNameFQ

    _.assign conf,
      scope: conf.scope
      scopeCC: scopeCC
      appNameKC: appNameKC
      appNameAsIs: appNameAsIs
      appNameFQ: appNameFQ
      appNameFQcC: appNameFQcC
      appNameFQCC: _.capitalize appNameFQcC
      npmToken: process.env["NPM_TOKEN_#{scopeCC}"]
      slackToken: process.env["SLACK_TOKEN_#{scopeCC}"]


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