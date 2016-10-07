var GarlicWebappGithubGenerator, _, chalk, generatorLib, jsonfile, path, util, yeoman;

util = require('util');

path = require('path');

yeoman = require('yeoman-generator');

chalk = require('chalk');

jsonfile = require('jsonfile');

_ = require('lodash');

generatorLib = require('../lib');

GarlicWebappGithubGenerator = yeoman.generators.Base.extend({
  initializing: {
    init: function() {
      console.log(chalk.magenta('You\'re using the GarlicTech webapp / commitizen generator.'));
      return generatorLib.createConfig.bind(this)();
    }
  },
  writing: {
    mainFiles: function() {
      var dest;
      dest = "./";
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
    }
  }
});

module.exports = GarlicWebappGithubGenerator;
