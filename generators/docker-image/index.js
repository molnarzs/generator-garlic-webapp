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
      console.log(chalk.magenta('You\'re using the GarlicTech webapp / docker image generator.'));
      return generatorLib.createConfig.bind(this)();
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
    return this.prompt({
      type: 'input',
      name: 'name',
      message: 'Docker image name (like foo-image): ',
      required: true
    }, cb.bind(this));
  },
  writing: {
    createConfig: function() {
      return this.conf.imageName = this.answers.name;
    },
    mainFiles: function() {
      var dest;
      dest = "./docker-images/" + this.answers.name;
      this.fs.copyTpl(this.templatePath('default/image/**/*'), this.destinationPath(dest), {
        c: this.conf
      });
      this.fs.copyTpl(this.templatePath('dotfiles/_dockerignore'), this.destinationPath(dest + "/.dockerignore"), {
        c: this.conf
      });
      return this.fs.copyTpl(this.templatePath('default/scripts/**/*'), this.destinationPath('./docker-images/scripts'), {
        c: this.conf
      });
    }
  }
});

module.exports = GarlicWebappGithubGenerator;
