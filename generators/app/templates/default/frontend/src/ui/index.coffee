WebFont = require 'webfontloader'
config = require '../config'
require './general'

WebFont.load
  google:
    families: ['Roboto:300,400,700']

Module = angular.module "#{config.MainModuleName}.ui", [
]
.directive 'gtFooter', require './footer'
.directive 'gtMainHeader', require './main-header'

module.exports = Module.name