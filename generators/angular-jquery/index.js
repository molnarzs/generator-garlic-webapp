var GarlicWebappAngularJqueryGenerator, _, chalk, fs, generatorLib, yeoman;

yeoman = require('yeoman-generator');

chalk = require('chalk');

_ = require('lodash');

fs = require('fs');

generatorLib = require('../lib');

GarlicWebappAngularJqueryGenerator = yeoman.generators.Base.extend({
  initializing: {
    init: function() {
      this.conf = this.config.getAll();
      return console.log(chalk.magenta('You\'re adding jquery to the angular app.'));
    }
  },
  writing: {
    "vendor/index.json": function() {
      var cb, content, path;
      cb = this.async();
      path = this.destinationPath("./src/vendor/index.coffee");
      content = fs.readFileSync(path, 'utf8');
      content = "require \"expose?$!expose?jQuery!jquery\"\n" + content;
      fs.writeFileSync(path, content, 'utf8');
      return cb();
    }
  },
  install: {
    dependencies: function() {
      this.npmInstall(['jquery'], {
        'save': true
      });
      return generatorLib.dependencies.bind(this)();
    }
  }
});

module.exports = GarlicWebappAngularJqueryGenerator;
