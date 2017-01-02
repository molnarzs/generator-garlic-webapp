var GarlicWebappGithubGenerator, _, chalk, cp, fs, generatorLib, path, util, yeoman;

util = require('util');

path = require('path');

yeoman = require('yeoman-generator');

chalk = require('chalk');

fs = require('fs-extra');

_ = require('lodash');

cp = require('glob-copy');

generatorLib = require('../lib');

GarlicWebappGithubGenerator = yeoman.generators.Base.extend({
  initializing: {
    init: function() {
      console.log(chalk.magenta('You\'re using the GarlicTech directive template importing generator.'));
      return generatorLib.createConfig.bind(this)();
    }
  },
  prompting: function() {
    var cb, done;
    done = this.async();
    this.answers = {};
    cb = (function(_this) {
      return function(answers) {
        _this.answers = _.assign(_this.answers, answers);
        return done();
      };
    })(this);
    return this.prompt([
      {
        type: 'input',
        name: 'moduleName',
        message: "Module name to be imported:"
      }
    ], cb.bind(this));
  },
  writing: {
    writeFiles: function() {
      var done;
      done = this.async();
      if (!fs.exists(path.join('src', 'templates'))) {
        this.fs.copyTpl(this.templatePath('default/**/*'), this.destinationPath("./src"), {
          c: this.conf
        });
      }
      return done();
    }
  },
  end: {
    writeModules: function() {
      var directives, done, indexFile, mainIndexFileContent, mainIndexFilePath, replacedText, srcAngularModuleName, srcDir, targetDir, yorc;
      done = this.async();
      this.moduleRootRemote = "/tmp/directive-import";
      fs.removeSync(this.moduleRootRemote);
      generatorLib.execute("git clone https://github.com/" + this.conf.scope + "/" + this.answers.moduleName + " " + this.moduleRootRemote);
      this.moduleRootLocal = path.join('src', 'templates', this.conf.scope, this.answers.moduleName);
      fs.mkdirsSync(this.moduleRootLocal);
      yorc = fs.readJsonSync(path.join(this.moduleRootRemote, '.yo-rc.json'));
      srcAngularModuleName = yorc['generator-garlic-webapp'].angularModuleName;
      directives = yorc['generator-garlic-webapp'].angularModules.directives;
      indexFile = "require './style'\n\nModule = angular.module '" + this.conf.angularModuleName + ".Templates." + srcAngularModuleName + "', []\n.run ['$templateCache', ($templateCache) ->\n";
      srcDir = path.join(this.moduleRootRemote, 'src', 'style');
      targetDir = path.join(this.moduleRootLocal, 'style');
      fs.mkdirsSync(targetDir);
      cp(path.join(srcDir, "*"), targetDir);
      _.forEach(directives, (function(_this) {
        return function(directive) {
          var directiveNameCC;
          srcDir = path.join(_this.moduleRootRemote, 'src', directive);
          targetDir = path.join(_this.moduleRootLocal, directive);
          fs.mkdirsSync(targetDir);
          cp(path.join(srcDir, "ui.*"), targetDir);
          cp(path.join(srcDir, "style.*"), targetDir);
          directiveNameCC = _.upperFirst(_.camelCase(directive));
          indexFile += "  require './" + directive + "/style'\n";
          return indexFile += "  $templateCache.put '" + srcAngularModuleName + "." + directiveNameCC + "', require './" + directive + "/ui'\n";
        };
      })(this));
      indexFile += "]\n\nmodule.exports = Module.name\n";
      fs.writeFileSync(path.join(this.moduleRootLocal, 'index.coffee'), indexFile);
      mainIndexFilePath = path.join('src', 'templates', 'index.coffee');
      mainIndexFileContent = fs.readFileSync(mainIndexFilePath, 'utf8');
      replacedText = "require './" + this.conf.scope + "/" + this.answers.moduleName + "'\n# ===== yeoman hook =====";
      mainIndexFileContent = mainIndexFileContent.replace('# ===== yeoman hook ====', replacedText);
      fs.writeFileSync(mainIndexFilePath, mainIndexFileContent, 'utf8');
      return done();
    }
  }
});

module.exports = GarlicWebappGithubGenerator;
