var cowsay = require('cowsay');
var pkginfo = require('../package.json');

console.log(chalk.blue(cowsay.say({
  text: pkginfo.description,
  e: "oO",
  T: 'U '
})));

console.log(chalk.blue("SERVER VERSION: ", pkginfo.version));

module.exports = function(app) {
  return require('./routes')(app);
};
