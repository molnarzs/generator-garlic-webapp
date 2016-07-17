# A [Yeoman](http://yeoman.io) generator to start a GarlicTech web app.

[![Build Status](https://travis-ci.org/garlictech/generator-garlic-webapp.svg?branch=master)](https://travis-ci.org/garlictech/generator-garlic-webapp)

## Getting Started

### Prerequistes

[Yeoman](http://yeoman.io) generator must be installed:

```bash
$ sudo npm install -g yeoman
```

### Setup
To install generator-garlic-webapp, run:

```bash
$ sudo npm install -g generator-garlic-webapp
```

## Generators

### Start a project

Create a project directory. Enter the directory, then:

```bash
$ yo garlic-webapp [--skip-install]
```

It scaffolds webapp. If you do not specify `--skip-install`, then the generator will install npm and bower and bower dependencies as well.


### Github authentication

You can give a github oauth token as an optional parameter. If you do so, and the token is valid, the generator will create a github repo out of the generated code, and commits it as initial version.

[How to create token.](https://help.github.com/articles/creating-an-access-token-for-command-line-use/)


## Development

Get the available gulp tasks with

```
gulp help
```
