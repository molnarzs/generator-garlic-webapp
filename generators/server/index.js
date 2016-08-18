var GarlicWebappServerGenerator, chalk, generatorLib, jsonfile, mkdirp, path, util, yeoman;

util = require('util');

path = require('path');

yeoman = require('yeoman-generator');

chalk = require('chalk');

mkdirp = require('mkdirp');

jsonfile = require('jsonfile');

generatorLib = require('../lib');

GarlicWebappServerGenerator = yeoman.generators.Base.extend({
  initializing: function() {
    this.config.set({
      appname: this.appname
    });
    console.log(chalk.magenta('You\'re using the GarlicTech webapp generator.'));
    return this.composeWith('loopback', {
      options: {
        "skip-install": true
      }
    });
  },
  prompting: function() {
    return generatorLib.prompting.bind(this)();
  },
  writing: {
    createConfig: function() {
      return generatorLib.createConfig.bind(this)();
    },
    mainFiles: function() {
      var cb;
      cb = this.async();
      this.fs.copyTpl(this.templatePath('default/**/*'), this.destinationPath("./"), {
        conf: this.conf
      });
      this.fs.copyTpl(this.templatePath('dotfiles/_travis.yml'), this.destinationPath("./.travis.yml"), {
        conf: this.conf
      });
      return cb();
    },
    "package.json": function() {
      var cb, pjson;
      cb = this.async();
      pjson = jsonfile.readFileSync(this.destinationPath("./package.json"));
      pjson.name = "@" + this.conf.scope + "/" + this.conf.appNameKC;
      pjson.version = "0.0.1";
      pjson.description = "" + this.conf.appNameAsIs;
      pjson.main = "dist/server.js";
      pjson.license = "SEE LICENSE IN license.txt";
      pjson.repository = {
        "type": "git",
        "url": "https://github.com/" + this.conf.scope + "/" + this.conf.appNameKC + ".git"
      };
      pjson.author = {
        "name": "" + this.conf.scopeCC,
        "email": "contact@" + this.conf.scope + ".com",
        "url": "http://www." + this.conf.scope + ".com"
      };
      pjson.contributors = ["Zsolt R. Molnar <zsolt@zsoltmolnar.hu> (http://www.zsoltmolnar.hu)"];
      pjson.keywords = ["" + this.conf.appName, "" + this.conf.appNameKC, "" + this.conf.scope];
      pjson.bugs = {
        "url": "https://github.com/" + this.conf.scope + "/" + this.conf.appNameKC + "/issues"
      };
      pjson.homepage = "https://github.com/" + this.conf.scope + "/" + this.conf.appNameKC + "/wiki/Home";
      pjson.devDependencies = {
        "garlictech-workflows-server": "^0.1"
      };
      pjson.dependencies["garlictech-common-server"] = "^0.0";
      pjson.engines = {
        "npm": ">=3.0.0",
        "node": ">=5.0.0"
      };
      pjson.scripts = {
        "build": "gulp build",
        "start": "node .",
        "start-dev": "gulp",
        "debug": "node --debug-brk dist/server.js",
        "unittest": "scripts/unittest.sh",
        "systemtest": "scripts/systemtest.sh",
        "setup-dev": "scripts/setup-dev.sh",
        "test": "npm run unittest && npm run systemtest",
        "posttest": "nsp check"
      };
      pjson.garlic = {
        "unittest": "./dist/test/unit/index.js"
      };
      pjson.config = {
        "port": 3000
      };
      jsonfile.spaces = 2;
      jsonfile.writeFileSync(this.destinationPath("./package.json"), pjson);
      return cb();
    },
    dotfiles: function() {
      return this.fs.copy(this.templatePath('default/.*'), this.destinationPath("./"));
    }
  },
  install: {
    setupEnvironment: function() {
      var cb;
      cb = this.async();
      generatorLib.execute("npm install");
      generatorLib.execute("npm run setup-dev");
      generatorLib.execute("npm run build");
      return cb();
    }
  }
});

module.exports = GarlicWebappServerGenerator;
