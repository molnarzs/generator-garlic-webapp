require './translations'

Module = angular.module "GarlicTech.Localize.TestApp", [
  'GarlicTech.Localize'
]

# First, register an unique translation module name, then add supported locales.
.config ['Localize.ConfigProvider', (ConfigProvider) ->
  ConfigProvider.registerModule 'localize'
  ConfigProvider.addSupportedLocales ['hu_HU']
]