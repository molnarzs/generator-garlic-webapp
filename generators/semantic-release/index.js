var GarlicWebappGithubGenerator, _, chalk, fs, generatorLib, jsonfile, path, util, yaml, yeoman;

util = require('util');

path = require('path');

yeoman = require('yeoman-generator');

chalk = require('chalk');

jsonfile = require('jsonfile');

_ = require('lodash');

yaml = require('node-yaml');

fs = require('fs');

generatorLib = require('../lib');

GarlicWebappGithubGenerator = yeoman.generators.Base.extend({
  initializing: {
    init: function() {
      console.log(chalk.magenta('You\'re using the GarlicTech webapp / semantic releasing generator.'));
      return generatorLib.createConfig.bind(this)();
    }
  },
  prompting: function() {
    var cb, dockerRepo, done, ref, ref1;
    done = this.async();
    if (((ref = this.options) != null ? (ref1 = ref.answers) != null ? ref1.dockerRepo : void 0 : void 0) != null) {
      this.conf.dockerRepo = this.options.answers.dockerRepo;
      return done();
    } else {
      cb = (function(_this) {
        return function(answers) {
          _this.conf.dockerRepo = answers.dockerRepo;
          return done();
        };
      })(this);
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
      var cb;
      cb = this.async();
      this.fs.copyTpl(this.templatePath('default/**/*'), this.destinationPath("./"), {
        c: this.conf
      });
      return cb();
    },
    "package.json": function() {
      var cb, pjson;
      cb = this.async();
      pjson = jsonfile.readFileSync(this.destinationPath("./package.json"));
      _.set(pjson, "scripts.semantic-release", "docker/semantic-release.sh");
      jsonfile.spaces = 2;
      jsonfile.writeFileSync(this.destinationPath("./package.json"), pjson);
      return cb();
    },
    "README.md": function() {
      var cb, content, fileName;
      cb = this.async();
      fileName = this.destinationPath("./README.md");
      content = fs.readFileSync(fileName, {
        encoding: 'utf8'
      });
      content = _.split(content, '\n');
      content.splice(2, 0, "[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)");
      content = _.join(content, '\n');
      fs.writeFileSync(fileName, content);
      return cb();
    }
  }
});

module.exports = GarlicWebappGithubGenerator;
