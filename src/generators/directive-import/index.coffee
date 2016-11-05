util = require 'util'
path = require 'path'
yeoman = require 'yeoman-generator'
chalk = require 'chalk'
fs = require 'fs-extra'
_ = require 'lodash'
cp = require 'glob-copy'
generatorLib = require '../lib'

GarlicWebappGithubGenerator = yeoman.generators.Base.extend
  initializing:
    init: ->
      console.log chalk.magenta 'You\'re using the GarlicTech directive template importing generator.'
      generatorLib.createConfig.bind(@)()


  prompting: ->
    done = @async()
    @answers = {}

    cb = (answers) =>
      @answers = _.assign @answers, answers
      done()

    @prompt [{
      type    : 'input'
      name    : 'moduleName'
      message : "Module name to be imported:"
    }], cb.bind @
 

  writing:
    writeFiles: ->
      done = @async()
      if not fs.exists path.join 'src', 'templates'
        @fs.copyTpl @templatePath('default/**/*'), @destinationPath("./src"), {c: @conf}
      done()


  end:
    writeModules: ->
      done = @async()
      @moduleRootRemote = "/tmp/directive-import"
      # fs.removeSync @moduleRootRemote
      # generatorLib.execute "git clone https://github.com/#{@conf.scope}/#{@answers.moduleName} #{@moduleRootRemote}"
      @moduleRootLocal = path.join 'src', 'templates', @conf.scope, @answers.moduleName
      fs.mkdirsSync @moduleRootLocal
      yorc = fs.readJsonSync path.join @moduleRootRemote, '.yo-rc.json'
      srcAngularModuleName = yorc['generator-garlic-webapp'].angularModuleName
      # directives = yorc.angularModules.directives
      directives = yorc['generator-garlic-webapp'].angularModules.ui

      indexFile = """
        Module = angular.module '#{@conf.angularModuleName}.Templates.#{srcAngularModuleName}', []
        .run ['$templateCache', ($templateCache) ->

      """

      _.forEach directives, (directive) =>
        srcDir = path.join @moduleRootRemote, 'src', directive
        targetDir = path.join @moduleRootLocal, directive
        fs.mkdirsSync targetDir
        cp path.join(srcDir, "ui.*"), targetDir
        cp path.join(srcDir, "style.*"), targetDir
        directiveNameCC = _.upperFirst _.camelCase directive
        indexFile += "  require './#{directive}/style'\n"
        indexFile += "  $templateCache.put '#{srcAngularModuleName}.#{directiveNameCC}', require './#{directive}/ui'\n"

      indexFile += """
        ]

        module.exports = Module.name\n
      """

      fs.writeFileSync path.join(@moduleRootLocal, 'index.coffee'), indexFile
      mainIndexFilePath = path.join 'src', 'templates', 'index.coffee'
      mainIndexFileContent = fs.readFileSync mainIndexFilePath, 'utf8'

      replacedText = """
        require './#{@conf.scope}/#{@answers.moduleName}'
        # ===== yeoman hook =====
      """

      mainIndexFileContent = mainIndexFileContent.replace '# ===== yeoman hook ====', replacedText
      fs.writeFileSync mainIndexFilePath, mainIndexFileContent, 'utf8'
      done()


module.exports = GarlicWebappGithubGenerator
