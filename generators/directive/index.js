var GarlicWebappDirectiveGenerator, _, chalk, fs, generatorLib, gulpFilter, gulpRename, path, spawn, util, yeoman;

util = require('util');

path = require('path');

yeoman = require('yeoman-generator');

chalk = require('chalk');

spawn = require('child_process').spawn;

_ = require('lodash');

fs = require('fs-extra');

path = require('path');

gulpFilter = require('gulp-filter');

gulpRename = require('gulp-rename');

generatorLib = require('../lib');

GarlicWebappDirectiveGenerator = yeoman.generators.Base.extend({
  initializing: {
    init: function() {
      if (!this.options.view) {
        console.log(chalk.magenta('You\'re using the GarlicTech webapp directive generator.'));
      }
      return this.folder = "./src";
    }
  },
  prompting: function() {
    var cb, done;
    if (this.options.view) {
      return;
    }
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
        name: 'name',
        message: 'Module name (like foo-component):',
        required: true
      }, {
        type: 'confirm',
        name: 'isExtractAllowed',
        message: 'Allow extracting the templates?',
        required: true,
        store: true,
        "default": true
      }
    ], cb.bind(this));
  },
  writing: {
    createConfig: function() {
      generatorLib.createDirectiveConfig.bind(this)();
      console.log("templateUrl: '" + this.conf.moduleName + "'");
      if (this.answers.isExtractAllowed) {
        this.conf.directiveHeader = "";
        this.conf.directiveTemplate = "templateUrl: '" + this.conf.moduleName + "'";
        return this.conf.cssGlobals = "";
      } else {
        this.conf.directiveHeader = "require './style'\n";
        this.conf.directiveTemplate = "template: require './ui'";
        return this.conf.cssGlobals = "@import \"~style/globals\";\n";
      }
    },
    mainFiles: function() {
      var root;
      root = "" + this.answers.name;
      if (this.options.view) {
        root = "views/" + this.answers.name + "-view";
      }
      return this.fs.copyTpl(this.templatePath('default/**/*'), this.destinationPath(this.folder + "/" + root), {
        c: this.conf
      });
    },
    "directive-modules.coffee": function() {
      var content, dest;
      if (this.options.view) {
        return;
      }
      dest = this.destinationPath(this.folder + "/directive-modules.coffee");
      content = "Module = angular.module \"" + this.conf.angularModuleName + ".Directives\", [";
      _.forEach(this.moduleNames, function(moduleName) {
        return content += "\n  require './" + moduleName + "'";
      });
      content += "\n]\n\nmodule.exports = Module.name";
      return this.fs.write(dest, content);
    },
    "test-view-components.jade": function() {
      var content, dest;
      if (this.options.view) {
        return;
      }
      dest = this.destinationPath(this.folder + "/views/test-view/test-view-components.jade");
      content = "";
      _.forEach(this.moduleNames, (function(_this) {
        return function(moduleName) {
          return content += _this.conf.appNameFQ + "-" + _this.answers.name + "\n";
        };
      })(this));
      return this.fs.write(dest, content);
    },
    saveConfig: function() {
      return this.config.set('angularModules', this.conf.angularModules);
    }
  },
  end: {
    templates: function() {
      var content, done, dstPath, newRoot, replacedText;
      if (!this.answers.isExtractAllowed) {
        return;
      }
      done = this.async();
      dstPath = this.destinationPath("./src/templates/index.coffee");
      if (!fs.existsSync(dstPath)) {
        newRoot = path.join(__dirname, '..', 'app', 'templates');
        this.sourceRoot(newRoot);
        this.fs.copyTpl(this.templatePath('default/src/templates/**/*'), this.destinationPath(this.folder + "/" + root), {
          conf: this.conf
        });
      }
      content = fs.readFileSync(dstPath, 'utf8');
      replacedText = "#===== yeoman hook =====\n  require '../" + this.answers.name + "/style'\n  $templateCache.put '" + this.conf.moduleName + "', require '../" + this.answers.name + "/ui'";
      content = content.replace('#===== yeoman hook =====', replacedText);
      fs.writeFileSync(dstPath, content, 'utf8');
      return done();
    }
  }
});

module.exports = GarlicWebappDirectiveGenerator;
