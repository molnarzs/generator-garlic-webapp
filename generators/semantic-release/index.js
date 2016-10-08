var GarlicWebappGithubGenerator, _, chalk, fs, generatorLib, jsonfile, path, util, yaml, yeoman,
  indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

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
  writing: {
    "package.json": function() {
      var cb, pjson;
      cb = this.async();
      pjson = jsonfile.readFileSync(this.destinationPath("./package.json"));
      _.set(pjson, "scripts.semantic-release", "docker/semantic-release.sh");
      pjson.version = "0.0.0-semantically-released";
      jsonfile.spaces = 2;
      jsonfile.writeFileSync(this.destinationPath("./package.json"), pjson);
      return cb();
    },
    ".travis.yml": function() {
      var cb, data, file;
      cb = this.async();
      file = this.destinationPath("./.travis.yml");
      data = yaml.readSync(file);
      if (!data.after_success) {
        data.after_success = [];
      }
      if ((data.after_success[0] == null) || indexOf.call(data.after_success[0], "npm run semantic-release") < 0) {
        data.after_success.unshift("[ \"${TRAVIS_PULL_REQUEST}\" = \"false\" ] && npm run semantic-release");
      }
      _.set(data, "cache.directories", "node_modules");
      yaml.writeSync(file, data);
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
