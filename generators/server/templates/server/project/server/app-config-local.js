require('source-map-support').install();
var cowsay = require('cowsay');
var chalk = require('chalk');
// The path below refers to the docker image location!
var pkginfo = require('/app/package.json');

console.log(chalk.blue(cowsay.say({
    text: pkginfo.description || chalk.red("Description in package.json is missing!!!"),
    e: "oO",
    T: 'U '
})));

if (!process.env.NODE_ENV) {
    throw new Error("NODE_ENV is undefined!");
}

console.log(chalk.blue("SERVER VERSION: ", pkginfo.version || chalk.red("Package version in package.json is missing!!!")));

module.exports = function(app) {
    if (process.env.NODE_ENV === 'production') {
        console.log("CORS stuff is disabled in " + process.env.NODE_ENV + " mode.");
    } else {
        app.use((require('cors'))());
        console.log("Enabled CORS stuff in development mode");
    }

    app.use((require('morgan'))('dev'));
    return require('./routes')(app);
};