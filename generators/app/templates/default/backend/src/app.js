cowsay = require("cowsay");
chalk = require('chalk');
console.log(chalk.blue(cowsay.say({text: "<%= appName %> backend server", e: "oO", T: 'U '})));

require('./globals');

var express = require('express');
var path = require('path');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');

var app = express();
var api = require('./routes/api');
var cors = require('cors');

app.use(cors());
app.use(logger('dev'));
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(cookieParser());
app.use('/api', api);

module.exports = app;
