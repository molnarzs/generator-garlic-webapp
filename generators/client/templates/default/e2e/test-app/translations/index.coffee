# Pattern after "!file?name=" must be translations/<unique id>/[name].json
# Unique ID must be the parameter of ConfigProvider.registerModule, in a module config section
require "!file?name=translations/localize/[name].json!hjson?str!./en_US.hjson"
require "!file?name=translations/localize/[name].json!hjson?str!./hu_HU.hjson"