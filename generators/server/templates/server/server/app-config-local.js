require('./globals');
var cowsay = require('cowsay');
// The path below refers to the docker image location!
var pkginfo = require('/app/package.json');

console.log(chalk.blue(cowsay.say({
  text: pkginfo.description,
  e: "oO",
  T: 'U '
})));

console.log(chalk.blue("SERVER VERSION: ", pkginfo.version));

module.exports = function(app) {
  app.use((require('morgan'))('dev'));
}
