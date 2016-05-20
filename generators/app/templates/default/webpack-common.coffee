path = require 'path'
webpack = require 'webpack'
plugins = require('webpack-load-plugins')()

#related to this bug: https://github.com/jtangelder/sass-loader/issues/100
process.env.UV_THREADPOOL_SIZE = 100

PATHS =
  src: path.join __dirname, 'src'
  dist: path.join __dirname, 'dist'
  test: path.join __dirname, 'src', 'test', 'protractor'
  node: path.join __dirname, 'node_modules'
  bower: path.join __dirname, 'bower_components'

config =
  context: __dirname
  debug: false
  devtool: 'source-map'
  module:
    preLoaders: [
      {test: /\.coffee$/, loader: 'coffeelint', exclude: 'node_modules'}
    ]
    loaders: [
      {test: /\.js$/, loader: 'jshint', exclude: /node_modules|bower_components/}
      {test: /\.scss$/, loader: plugins.extractText.extract('style-loader', "css?sourceMap!postcss!sass?sourceMap")}
      {test: /\.css$/, loader: plugins.extractText.extract("style-loader", "css!postcss")}
      {test: /\.less$/, loader: 'style!css!postcss|less'}
      {test: /\.styl$/, loader: plugins.extractText.extract("style-loader", "css!stylus")}
      {test: /\.coffee$/, loader: 'coffee', exclude: 'node_modules'}
      {test: /\.jade$/, loader: "html!jade-html"}
      {test: /\.html$/, loader: 'html'}
      {test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/, loader: "url-loader?limit=10000&minetype=application/font-woff"}
      {test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/, loader: "file-loader"}
      {test: /\.jpg$/, loader: 'file-loader?mimetype=image/jpg&limit=10000'}
      {test: /\.gif$/, loader: 'file-loader?mimetype=image/gif&limit=10000'}
      {test: /\.png$/, loader: 'file-loader?mimetype=image/png&limit=10000'}
      {test: /\.json$/, loader: 'json'}
      {test: /imagesloaded/, loader: 'imports?define=>false'}
    ]
    postLoaders: [
      # {test: /\.coffee/, loader: 'istanbul-instrumenter', exclude: 'node_modules|unit'}
    ]
    noParse: []

  postcss: -> [ require('precss'),
    require('autoprefixer')({browsers: ['last 2 versions', 'ie >= 9', 'and_chr >= 2.3']})
  ]

  sassLoader: {
    includePaths: [ path.join(PATHS.node, 'normalize-scss', 'sass')]
  },
  
  plugins: [
    # new webpack.optimize.UglifyJsPlugin {minimize: true},
    # new webpack.optimize.DedupePlugin()

    new webpack.ProvidePlugin
      _: "lodash"
      jQuery: 'jquery'
      $: "jquery"
      "window.jQuery": "jquery"
      "config": "config.coffee"

    new plugins.html
      inject: true
      template: path.join PATHS.src, 'index.html'

    new plugins.extractText "style.css",
      allChunks: true
  ]

  resolve:
    extensions: ["", ".webpack.js", ".web.js", ".js", ".coffee", ".styl", ".jade", ".pug", ".scss", '.css']
    
    root: [
      PATHS.node,
      PATHS.bower
    ]
    
    modulesDirectories: [
      'src',
      'node_modules',
      'bower_components'
    ]
    
    alias: []
    unsafeCache: true

module.exports =
  config: config
  paths: PATHS