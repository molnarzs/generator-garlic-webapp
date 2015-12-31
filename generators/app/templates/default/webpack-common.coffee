path = require 'path'
webpack = require 'webpack'
HtmlWebpackPlugin = require 'html-webpack-plugin'
ExtractTextPlugin = require 'extract-text-webpack-plugin'

#related to this bug: https://github.com/jtangelder/sass-loader/issues/100
process.env.UV_THREADPOOL_SIZE = 100

PATHS =
  src: path.join __dirname, 'frontend', 'src'
  dist: path.join __dirname, 'frontend', 'dist'
  test: path.join __dirname, 'frontend', 'src', 'test', 'protractor'
  node: path.join __dirname, 'node_modules'
  bower: path.join __dirname, 'bower_components'
  complib_node: path.join __dirname, 'node_modules', 'gt-complib', 'node_modules'
  complib_bower: path.join __dirname, 'node_modules', 'gt-complib', 'bower_components'

config =
  context: __dirname
  debug: false
  devtool: 'source-map'
  module:
    preLoaders: [
      {test: /\.coffee$/, loader: 'coffeelint', exclude: 'node_modules'}
    ]
    loaders: [
      {test: /\.js$/, loader: 'jshint', exclude: /node_modules|bower_components|gt-utils|gt-account-handling/}
      {test: /\.scss$/, loader: ExtractTextPlugin.extract('style-loader', "css?sourceMap!autoprefixer!sass?sourceMap&includePaths[]=#{path.resolve(__dirname, 'node_modules')}&includePaths[]=#{path.resolve(__dirname, 'src')}")}
      {test: /\.css$/, loader: ExtractTextPlugin.extract("style-loader", "css!autoprefixer")}
      {test: /\.less$/, loader: 'style!css!autoprefixer|less'}
      {test: /\.styl$/, loader: ExtractTextPlugin.extract("style-loader", "css!stylus")}
      {test: /\.coffee$/, loader: 'coffee', exclude: 'node_modules'}
      {test: /\.jade$/, loader: "html!jade-html"}
      {test: /\.html$/, loader: 'html'}
      {test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/, loader: "url-loader?limit=10000&minetype=application/font-woff"}
      {test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/, loader: "file-loader"}
      {test: /\.jpg$/, loader: 'file-loader?mimetype=image/jpg&limit=10000'}
      {test: /\.gif$/, loader: 'file-loader?mimetype=image/gif&limit=10000'}
      {test: /\.png$/, loader: 'file-loader?mimetype=image/png&limit=10000'}
      {test: /\.json$/, loader: 'json', exclude: /translations/}
      {test: /imagesloaded/, loader: 'imports?define=>false'}
    ]
    postLoaders: [
      # {test: /\.coffee/, loader: 'istanbul-instrumenter', exclude: 'node_modules|unit'}
    ]
    noParse: []

  plugins: [
    # new webpack.optimize.UglifyJsPlugin {minimize: true},
    # new webpack.optimize.DedupePlugin()

    new webpack.ProvidePlugin
      _: "lodash"
      jQuery: 'jquery'
      $: "jquery"
      "window.jQuery": "jquery"

    new HtmlWebpackPlugin
      inject: true
      template: path.join PATHS.src, 'index.html'

    new ExtractTextPlugin "style.css",
      allChunks: true
  ]

  resolve:
    extensions: ["", ".webpack.js", ".web.js", ".js", ".coffee", ".styl", ".jade", ".scss", '.css']
    
    root: [
      PATHS.node,
      PATHS.bower,
      PATHS.complib_node,
      PATHS.complib_bower,
    ]
    
    modulesDirectories: [
      'src'
      'frontend/src',
      'node_modules',
      'bower_components'
    ]
    
    alias: []
    unsafeCache: true

module.exports =
  config: config
  paths: PATHS