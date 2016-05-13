require 'colors'
GLOBAL.winston = require 'winston'
winston.level = 'debug'
chai = require 'chai'

GLOBAL._ = require 'lodash'
GLOBAL.sinon = require 'sinon'
GLOBAL.Promise = require 'bluebird'
GLOBAL.fs = require 'fs'
GLOBAL.should = chai.should()
GLOBAL.expect = chai.expect

GLOBAL.config = require '../config'

GLOBAL.test =
  getMockClock: (dateString) ->
    if dateString then sinon.useFakeTimers(new Date(dateString).getTime()) else sinon.useFakeTimers()