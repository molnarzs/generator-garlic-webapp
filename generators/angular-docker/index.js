var GarlicWebappGithubGenerator, _, chalk, generatorLib, jsonfile, path, util, yeoman;

util = require('util');

path = require('path');

yeoman = require('yeoman-generator');

chalk = require('chalk');

_ = require('lodash');

jsonfile = require('jsonfile');

generatorLib = require('../lib');

GarlicWebappGithubGenerator = yeoman.generators.Base.extend({
  initializing: {
    init: function() {
      console.log(chalk.magenta('You\'re using the GarlicTech webapp / angular docker files generator.'));
      generatorLib.createConfig.bind(this)();
      this.conf.webpackServerName = this.conf.scope + "." + this.conf.appNameKC + ".webpack-server";
      this.conf.distImageName = this.conf.dockerRepo + "/" + this.conf.appNameKC;
      return this.conf.e2eTesterName = this.conf.scope + "." + this.conf.appNameKC + ".e2e-tester";
    }
  },
  prompting: function() {
    var cb, dockerRepo, done, ref;
    done = this.async();
    cb = (function(_this) {
      return function(answers) {
        _this.answers = answers;
        _this.conf.dockerRepo = answers.dockerRepo;
        return done();
      };
    })(this);
    if (((ref = this.options.answers) != null ? ref.dockerRepo : void 0) != null) {
      return cb(this.options.answers);
    } else {
      dockerRepo = "docker." + this.conf.scope + ".com";
      return this.prompt([
        {
          type: 'input',
          name: 'dockerRepo',
          "default": dockerRepo,
          message: 'Docker repo:',
          store: true
        }
      ], cb.bind(this));
    }
  },
  writing: {
    mainFiles: function() {
      var dest;
      dest = "./";
      this.fs.copyTpl(this.templatePath('default/**/*'), this.destinationPath(dest), {
        c: this.conf
      });
      return this.fs.copyTpl(this.templatePath('dotfiles/_dockerignore'), this.destinationPath(dest + "/.dockerignore"), {
        c: this.conf
      });
    },
    "package.json": function() {
      var cb, pjson;
      cb = this.async();
      pjson = jsonfile.readFileSync(this.destinationPath("./package.json"));
      _.forEach(['start', 'stop', 'unittest', 'build', 'e2etest', 'bash', 'gulp', 'dist'], function(label) {
        return _.set(pjson, "scripts." + label, "docker/" + label + ".sh");
      });
      _.forEach(['start', 'unittest', 'dist'], function(label) {
        return _.set(pjson, "scripts." + label + ":docker", "scripts/" + label + ".sh");
      });
      _.set(pjson, "scripts.setup-dev", "scripts/setup-dev.sh");
      _.set(pjson, "scripts.unittest:single", "export NODE_ENV=test; docker/unittest.sh");
      _.set(pjson, "scripts.Build", "npm run build -- --no-cache");
      jsonfile.spaces = 2;
      jsonfile.writeFileSync(this.destinationPath("./package.json"), pjson);
      return cb();
    },
    commitizen: function() {
      var cb;
      cb = this.async();
      this.composeWith('garlic-webapp:commitizen', {
        options: {
          answers: this.answers
        }
      });
      return cb();
    },
    "semantic-release": function() {
      var cb;
      cb = this.async();
      this.composeWith('garlic-webapp:semantic-release', {
        options: {
          answers: this.answers
        }
      });
      return cb();
    }
  }
});

module.exports = GarlicWebappGithubGenerator;
