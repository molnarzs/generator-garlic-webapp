gulp = require 'gulp'

config =
  root: __dirname
  srcRoot: 'server'

gulp = require("garlictech-workflows-server/dist/gulp")(gulp, config)
