var GarlicWebappGenerator, _, chalk, execute, mkdirp, path, util, yeoman;

util = require('util');

path = require('path');

yeoman = require('yeoman-generator');

chalk = require('chalk');

_ = require('lodash');

mkdirp = require('mkdirp');

execute = require('child_process').execSync;

GarlicWebappGenerator = yeoman.generators.Base.extend({
  initializing: {
    init: function() {
      this.config.set({
        appName: this.appname,
        angularModules: {
          ui: [],
          services: [],
          factories: [],
          pages: []
        },
        backend: {
          components: []
        },
        common: {
          components: []
        }
      });
      return console.log(chalk.magenta('You\'re using the GarlicTech webapp generator.'));
    }
  },
  writing: {
    mainFiles: function() {
      this.conf = this.config.getAll();
      this.fs.copyTpl(this.templatePath('default/**/*'), this.destinationPath("./"), {
        appName: _.kebabCase(this.conf.appName),
        appNameCC: _.capitalize(_.camelCase(this.conf.appName)),
        appNameAsIs: this.conf.appName
      });
      return this.fs.copy(this.templatePath('default_assets/**/*'), this.destinationPath("./frontend/src/"));
    },
    "frontend/ui-modules.coffee": function() {
      var dest;
      dest = this.destinationPath("./frontend/src/ui-modules.coffee");
      if (!this.fs.exists(dest)) {
        return this.fs.write(dest, "Module = angular.module \"" + this.conf.appName + "-ui\", []\nmodule.exports = Module.name");
      }
    },
    "frontend/service-modules.coffee": function() {
      var dest;
      dest = this.destinationPath("./frontend/src/service-modules.coffee");
      if (!this.fs.exists(dest)) {
        return this.fs.write(dest, "Module = angular.module \"" + this.conf.appName + "-services\", []\nmodule.exports = Module.name");
      }
    },
    "frontend/factory-modules.coffee": function() {
      var dest;
      dest = this.destinationPath("./frontend/src/factory-modules.coffee");
      if (!this.fs.exists(dest)) {
        return this.fs.write(dest, "Module = angular.module \"" + this.conf.appName + "-factories\", []\nmodule.exports = Module.name");
      }
    },
    "frontend/views/test-page/test-page-components.jade": function() {
      var dest;
      dest = this.destinationPath("./frontend/src/views/test-page/test-page-components.jade");
      if (!this.fs.exists(dest)) {
        return this.fs.write(dest, "");
      }
    },
    dotfiles: function() {
      return this.fs.copy(this.templatePath('default/.*'), this.destinationPath("./"));
    }
  },
  install: {
    dependencies: function() {
      var cb;
      cb = this.async();
      console.log("\nLinking gt-complib.\n");
      this.spawnCommand('npm', ['link', 'gt-complib']);
      return cb();
    },
    createLocalGitRepo: function() {
      var done, pwd, repoName, repoRoot;
      done = this.async();
      repoRoot = process.env.GIT_REPOS_ROOT;
      if (!repoRoot) {
        return console.log("Git repo creation skipped (no GIT_REPOS_ROOT env. variable set)");
      } else if (this.options['skip-install']) {
        return console.log("Git repo creation skipped");
      } else {
        console.log("Creating local git repo to " + repoRoot);
        pwd = process.cwd();
        repoName = this.conf.appName + ".git";
        process.chdir(repoRoot);
        mkdirp.sync(repoName);
        process.chdir(repoName);
        execute("git init --bare");
        process.chdir(pwd);
        execute("git init");
        execute("git remote add origin " + repoRoot + "/" + repoName);
        execute("git add .");
        execute("git commit -m 'Initial version.'");
        execute('git push -u origin master');
        return done();
      }
    }
  }
});

module.exports = GarlicWebappGenerator;
