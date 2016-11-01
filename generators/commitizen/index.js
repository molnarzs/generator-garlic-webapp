var GarlicWebappGithubGenerator, _, chalk, fs, generatorLib, jsonfile, path, util, yeoman;

util = require('util');

path = require('path');

yeoman = require('yeoman-generator');

chalk = require('chalk');

jsonfile = require('jsonfile');

_ = require('lodash');

fs = require('fs');

generatorLib = require('../lib');

GarlicWebappGithubGenerator = yeoman.generators.Base.extend({
  initializing: {
    init: function() {
      console.log(chalk.magenta('You\'re using the GarlicTech webapp / commitizen generator.'));
      return generatorLib.createConfig.bind(this)();
    }
  },
  prompting: function() {
    var cb, done, ref;
    done = this.async();
    this.answers = {};
    cb = (function(_this) {
      return function(answers) {
        _this.answers = _.assign(_this.answers, answers);
        return done();
      };
    })(this);
    if (((ref = this.options.answers) != null ? ref.dockerRepo : void 0) != null) {
      this.answers.dockerRepo = this.options.answers.dockerRepo;
      return done();
    } else {
      return this.prompt([
        {
          type: 'input',
          name: 'dockerRepo',
          "default": "docker." + this.conf.scope + ".com",
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
      this.conf.dockerRepo = this.answers.dockerRepo;
      console.log(this.conf);
      return this.fs.copyTpl(this.templatePath('default/**/*'), this.destinationPath(dest), {
        c: this.conf
      });
    },
    "package.json": function() {
      var cb, pjson;
      cb = this.async();
      pjson = jsonfile.readFileSync(this.destinationPath("./package.json"));
      _.set(pjson, 'config.commitizen.path', "/app/node_modules/cz-conventional-changelog");
      _.set(pjson, "scripts.commit", "docker/commit.sh");
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
      content.splice(2, 0, "[![Commitizen friendly](https://img.shields.io/badge/commitizen-friendly-brightgreen.svg)](http://commitizen.github.io/cz-cli/)");
      content = _.join(content, '\n');
      fs.writeFileSync(fileName, content);
      return cb();
    }
  }
});

module.exports = GarlicWebappGithubGenerator;
