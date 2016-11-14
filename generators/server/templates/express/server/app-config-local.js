var cowsay = require('cowsay');
var pkginfo = require(__dirname + '/package.json');

console.log(chalk.blue(cowsay.say({
    text: pkginfo.description,
    e: "oO",
    T: 'U '
})));

console.log(chalk.blue("SERVER VERSION: ", pkginfo.version));

module.exports = function(app) {

    if (process.env.NODE_ENV === 'production') {
        console.log("CORS stuff is disabled in " + process.env.NODE_ENV + " mode.");
    } else {
        app.use((require('cors'))());
        console.log("Enabled CORS stuff in development mode");
    }

    return require('./routes')(app);
};
