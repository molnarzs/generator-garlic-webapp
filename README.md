> A [Yeoman](http://yeoman.io) generator to start a GarlicTech web app.

## Getting Started

### Prerequistes

[Yeoman](http://yeoman.io) generator must be installed:

```bash
$ sudo npm install -g yeoman
```

### Setup
To install generator-garlic-webapp, run:

```bash
$ sudo npm install -g git://github.com/garlictech/generator-garlic-webapp.git
```

### Github authentication

You can give a github oauth token as an optional parameter. If you do so, and the token is valid, the generator will create a github repo out of the generated code, and commits it as initial version.

(How to create token.)[https://help.github.com/articles/creating-an-access-token-for-command-line-use/]


### Start a project

Create a project directory. Project directory name must be the github project name as well. Enter the directory, then:

```bash
$ yo garlic-webapp [<github token>] [--skip-install]
```

It scaffolds webapp. Installed components will be:

* gulp, with various tasks
* drywall-based user management system 
* coffee, less, sass support

If you do not specify `--skip-install`, then the generator will install npm and bower dependencies as well.

## Usage

We have the following gulp tasks:

### default

```bash
gulp
```

It starts the following services:

* the server, available in http://localhost:9000. Gulp monitor server sources, on change, it restarts the server automatically.
* selenium server for automated in-browser testing.
* live reload service: if frontend files change, it reloads the actual browser page.
* watches file changes: compiles coffee, less, sass files, uglifies js files, checks code with lint tools, etc.

### test_chrome

```bash
gulp test_chrome
```

Execute Cucumber tests in Google Chrome browser.

### test_phantomjs

```bash
gulp test_phantomjs
```

Execute Cucumber tests in PhantomJS headless browser.

### test_firefox

```bash
gulp test_firefox
```

Execute Cucumber tests in Firefox browser.

### build

```bash
gulp build
```

Builds the production web site in `dist` folder.


