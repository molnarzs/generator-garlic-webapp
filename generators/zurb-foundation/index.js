var GarlicWebappZurbFoundationGenerator, _, chalk, fs, generatorLib, jsonfile, yeoman;

yeoman = require('yeoman-generator');

chalk = require('chalk');

_ = require('lodash');

fs = require('fs');

jsonfile = require('jsonfile');

generatorLib = require('../lib');

GarlicWebappZurbFoundationGenerator = yeoman.generators.Base.extend({
  initializing: {
    init: function() {
      this.conf = this.config.getAll();
      return console.log(chalk.magenta('You\'re adding Zurb Foundation to the angular app.'));
    }
  },
  writing: {
    mainFiles: function() {
      var cb;
      cb = this.async();
      this.fs.copyTpl(this.templatePath('default/**/*'), this.destinationPath("./"));
      return cb();
    },
    "src/style/index.coffee": function() {
      var cb, content, path;
      cb = this.async();
      path = this.destinationPath("./src/style/index.coffee");
      content = "require \"foundation-sites/dist/foundation.js\"\n" + fs.readFileSync(path, 'utf8');
      fs.writeFileSync(path, content, 'utf8');
      return cb();
    },
    "src/style/style.scss": function() {
      var cb, content, path, replacedText;
      cb = this.async();
      path = this.destinationPath("./src/style/style.scss");
      content = fs.readFileSync(path, 'utf8');
      replacedText = "@import \"foundation\";\n@import \"./foundation-settings\";\n@include foundation-everything($flex: true);\n// ===== yeoman hook imports end =====";
      content = content.replace('// ===== yeoman hook imports end =====', replacedText);
      fs.writeFileSync(path, content, 'utf8');
      return cb();
    },
    "package.json": function() {
      var cb, pjson;
      cb = this.async();
      this.conf = this.config.getAll();
      pjson = jsonfile.readFileSync(this.destinationPath("./package.json"));
      pjson.dependencies['jquery'] = "^2.0";
      jsonfile.spaces = 2;
      jsonfile.writeFileSync(this.destinationPath("./package.json"), pjson);
      return cb();
    },
    "webpack.common.config.js": function() {
      var cb, content, path, replacedText;
      cb = this.async();
      path = this.destinationPath("./webpack.common.config.js");
      content = fs.readFileSync(path, 'utf8');
      replacedText = "config.module.loaders.push({test: /foundation\..*\.js$/, loader: 'babel', query: {presets: ['react', 'es2015']}});\nconfig.sassLoader.includePaths.push('node_modules/foundation-sites/scss');\n// ===== yeoman hook config end =====";
      content = content.replace('// ===== yeoman hook config end =====', replacedText);
      fs.writeFileSync(path, content, 'utf8');
      return cb();
    }
  },
  install: {
    dependencies: function() {
      this.npmInstall(['foundation-sites'], {
        'save': true
      });
      return this.npmInstall(['babel-loader', 'babel-preset-es2015', 'babel-preset-react'], {
        'saveDev': true
      });
    }
  }
});

module.exports = GarlicWebappZurbFoundationGenerator;
