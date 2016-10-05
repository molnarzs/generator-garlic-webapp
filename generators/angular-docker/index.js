var GarlicWebappGithubGenerator, _, chalk, generatorLib, path, util, yeoman;

util = require('util');

path = require('path');

yeoman = require('yeoman-generator');

chalk = require('chalk');

_ = require('lodash');

generatorLib = require('../lib');

GarlicWebappGithubGenerator = yeoman.generators.Base.extend({
  initializing: {
    init: function() {
      console.log(chalk.magenta('You\'re using the GarlicTech webapp / angular docker files generator.'));
      generatorLib.createConfig.bind(this)();
      this.conf.webpackServerName = this.conf.scope + "." + this.conf.appNameKC + ".webpack-server";
      return this.conf.e2eTesterName = this.conf.scope + "." + this.conf.appNameKC + ".e2e-tester";
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
    }
  }
});

module.exports = GarlicWebappGithubGenerator;
