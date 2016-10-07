var GarlicWebappGithubGenerator, _, chalk, generatorLib, jsonfile, path, util, yaml, yeoman,
  indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

util = require('util');

path = require('path');

yeoman = require('yeoman-generator');

chalk = require('chalk');

jsonfile = require('jsonfile');

_ = require('lodash');

yaml = require('node-yaml');

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
      _.set(pjson, "scripts.semantic-release", "semantic-release pre && npm publish && semantic-release post");
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
        data.after_success.unshift("npm run semantic-release");
      }
      _.set(data, "cache.directories", "node_modules");
      yaml.writeSync(file, data);
      return cb();
    }
  }
});

module.exports = GarlicWebappGithubGenerator;
