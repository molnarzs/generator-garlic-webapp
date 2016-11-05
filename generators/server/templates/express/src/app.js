var app, bodyParser, cowsay, passport;

process.on('uncaughtException', function(err) {
  return console.log(err.stack);
});

require('./globals');

passport = require("passport");

app = (require('express'))();

app.use((require('helmet'))());

app.use((require('cors'))());

app.use((require('morgan'))('dev'));

app.use(passport.initialize());

bodyParser = require('body-parser');

app.use(bodyParser.urlencoded({
  extended: true
}));

app.use(bodyParser.json());

app.use((require('cookie-parser'))());

(require('./app-config-local'))(app);

module.exports = app;
