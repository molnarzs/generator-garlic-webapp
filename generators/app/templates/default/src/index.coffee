require './globals'
require './vendor'
require './style'

Module = angular.module "<%= conf.angularModuleName %>", [
  #===== yeoman hook modules =====#
  # NB! The above line is required for garlic yeoman generator and should not be changed. Otherwise, you are cursed.
  # If you do not know what garlic is in this context then do whatever you want to do.
  require './views'
  require './footer'
  require './main-header'
  require './directive-modules'
  require './service-modules'
  require './factory-modules'
  require './provider-modules'
]

module.exports = Module.name