'use strict'

_ = require 'lodash'

a=1
module.exports = _.merge(
 require './env/all.js'
 require './env/' + process.env.NODE_ENV + '.js' || {}
 )
