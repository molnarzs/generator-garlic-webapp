var GarlicWebappAngularFirebaseGenerator, _, chalk, fs, generatorLib, yeoman;

yeoman = require('yeoman-generator');

chalk = require('chalk');

_ = require('lodash');

fs = require('fs');

generatorLib = require('../lib');

GarlicWebappAngularFirebaseGenerator = yeoman.generators.Base.extend({
  initializing: {
    init: function() {
      this.conf = this.config.getAll();
      return console.log(chalk.magenta('You\'re adding firebase to the angular app.'));
    }
  },
  prompting: function() {
    var cb, done;
    done = this.async();
    cb = (function(_this) {
      return function(answers) {
        _this.answers = answers;
        return done();
      };
    })(this);
    return this.prompt([
      {
        type: 'input',
        name: 'apiKey',
        message: 'API key: ',
        required: true
      }, {
        type: 'input',
        name: 'authDomain',
        message: 'Auth domain: ',
        required: true
      }, {
        type: 'input',
        name: 'databaseURL',
        message: 'Database URL: ',
        required: true
      }, {
        type: 'input',
        name: 'storageBucket',
        message: 'Storage Bucket: ',
        required: true
      }
    ], cb.bind(this));
  },
  writing: {
    createConfig: function() {
      this.conf.service = "firebase-service";
      this.conf = _.assign(this.conf, generatorLib.createConfig.bind(this)());
      this.moduleNames = this.conf.angularModules.services;
      this.moduleNames.push(this.conf.service);
      this.conf.serviceName = _.upperFirst(_.camelCase(this.conf.service));
      this.conf.moduleName = this.conf.angularModuleName + "." + this.conf.serviceName;
      this.conf.serviceNameFQ = this.conf.moduleName;
      return this.conf = _.assign(this.conf, this.answers);
    },
    mainFiles: function() {
      return this.fs.copyTpl(this.templatePath('default/**/*'), this.destinationPath("./src/" + this.conf.service), {
        c: this.conf
      });
    },
    "vendor/index.json": function() {
      var cb, content, path;
      cb = this.async();
      path = this.destinationPath("./src/vendor/index.coffee");
      content = fs.readFileSync(path, 'utf8');
      content = content + "require 'angularfire'\n";
      fs.writeFileSync(path, content, 'utf8');
      return cb();
    },
    "service-modules.coffee": function() {
      var content, dest;
      dest = this.destinationPath("./src/service-modules.coffee");
      content = "Module = angular.module \"" + this.conf.angularModuleName + ".Services\", [";
      _.forEach(this.moduleNames, function(moduleName) {
        return content += "\n  require './" + moduleName + "'";
      });
      content += "\n]\n\nmodule.exports = Module.name";
      return this.fs.write(dest, content);
    },
    saveConfig: function() {
      return this.config.set('angularModules', this.conf.angularModules);
    }
  },
  install: {
    dependencies: function() {
      return this.npmInstall(['firebase', 'angularfire'], {
        'save': true
      });
    }
  }
});

module.exports = GarlicWebappAngularFirebaseGenerator;
