require "!file?name=translations/<%= appName %>/[name].json!hjson?str!./en_US.hjson"
require "!file?name=translations/<%= appName %>/[name].json!hjson?str!./hu_HU.hjson"

Module = angular.module "<%= appNameCC %>.Translations", []
.config ['$translateProvider', '$translatePartialLoaderProvider', ($translateProvider, $translatePartialLoaderProvider) ->
  $translatePartialLoaderProvider.addPart '<%= appName %>'
]

module.exports = Module.name