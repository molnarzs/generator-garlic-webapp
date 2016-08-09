var _;

_ = require('lodash');

module.exports = {
  createConfig: function() {
    var appNameAsIs, appNameFQ, appNameFQcC, appNameKC, conf, scopeCC;
    conf = this.config.getAll();
    scopeCC = _.capitalize(_.camelCase(conf.scope));
    appNameAsIs = scopeCC + " " + conf.appname;
    appNameKC = _.kebabCase(conf.appname);
    appNameFQ = _.kebabCase(appNameAsIs);
    appNameFQcC = _.camelCase(appNameFQ);
    return _.assign(conf, {
      scope: conf.scope,
      scopeCC: scopeCC,
      appNameKC: appNameKC,
      appNameAsIs: appNameAsIs,
      appNameFQ: appNameFQ,
      appNameFQcC: appNameFQcC,
      appNameFQCC: _.capitalize(appNameFQcC),
      npmToken: process.env["NPM_TOKEN_" + scopeCC],
      slackToken: process.env["SLACK_TOKEN_" + scopeCC]
    });
  },
  prompting: function() {
    var cb, done;
    done = this.async();
    cb = (function(_this) {
      return function(answers) {
        _this.answers = answers;
        _this.config.set({
          scope: _this.answers.scope
        });
        return done();
      };
    })(this);
    return this.prompt([
      {
        type: 'input',
        name: 'scope',
        "default": 'garlictech',
        message: 'Project scope (company github team):'
      }
    ], cb.bind(this));
  },
  dependencies: function() {
    var cb;
    cb = this.async();
    if (!this.options['skip-install']) {
      this.installDependencies();
    }
    return cb();
  }
};
