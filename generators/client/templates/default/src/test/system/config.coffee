credentials = require '../../credentials'

module.exports =
  mongoConnectionString: "mongodb://#{credentials.mongoUser}:#{credentials.mongoPassword}@ds033285.mongolab.com:33285/tableau-excel-scheduler-tool"
