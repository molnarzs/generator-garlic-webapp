yeoman = require('yeoman-generator')
chalk = require('chalk')
_ = require 'lodash'
fs = require 'fs'
jsonfile = require 'jsonfile'
generatorLib = require '../lib'

GarlicWebappZurbFoundationGenerator = yeoman.generators.Base.extend
  initializing:
    init: ->
      @conf = @config.getAll()
      console.log chalk.magenta 'You\'re adding Zurb Foundation to the angular app.'

  writing:
    mainFiles: ->
      cb = @async()
      @fs.copyTpl @templatePath('default/**/*'), @destinationPath("./")
      cb()


    "src/style/index.coffee": ->
      cb = @async()
      path = @destinationPath "./src/style/index.coffee"

      content = """
        require "foundation-sites/dist/foundation.js"\n
      """ + fs.readFileSync path, 'utf8'

      fs.writeFileSync path, content, 'utf8'
      cb()


    "src/style/style.scss": ->
      cb = @async()
      path = @destinationPath "./src/style/style.scss"
      content = fs.readFileSync path, 'utf8'

      replacedText = """
        @import "foundation";
        @import "./foundation-settings";
        @include foundation-everything($flex: true);
        // ===== yeoman hook imports end ====="""

      content = content.replace '// ===== yeoman hook imports end =====', replacedText
      fs.writeFileSync path, content, 'utf8'
      cb()


    "package.json": ->
      cb = @async()
      @conf = @config.getAll()
      pjson = jsonfile.readFileSync @destinationPath("./package.json")
      pjson.dependencies['jquery'] = "^2.0"
      jsonfile.spaces = 2
      jsonfile.writeFileSync @destinationPath("./package.json"), pjson
      cb()


    "hooks/webpack.js": ->
      cb = @async()
      path = @destinationPath "./hooks/webpack.js"
      content = fs.readFileSync path, 'utf8'

      replacedText = """
          config.module.loaders.push({test: /foundation\..*\.js$/, loader: 'babel', query: {presets: ['react', 'es2015']}});
          config.sassLoader.includePaths.push('node_modules/foundation-sites/scss');
          // ===== yeoman hook config end =====
      """

      content = content.replace '// ===== yeoman hook config end =====', replacedText
      fs.writeFileSync path, content, 'utf8'
      cb()


  install:
    dependencies: ->
      @npmInstall ['foundation-sites'], { 'save': true }
      @npmInstall ['babel-loader', 'babel-preset-es2015', 'babel-preset-react' ], { 'saveDev': true }

module.exports = GarlicWebappZurbFoundationGenerator
