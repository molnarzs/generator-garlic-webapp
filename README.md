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

The generator has some peer dependencies. If they are missing (for instance, the [loopback.io generator](https://github.com/strongloop/generator-loopback)), you must also install them globally.

# The Generators

## General remarks

* Some of the generators ask for scope. The scope must be the organization id in github (so, for garlictech projects, it must be garlictech. You can see this ID in the URL of the github repos).
* Some of the generator questions provide default values. They are either calculated (for example, based on the current directory), or the generator records the last value you selected, and offers that.
* Selecting a default: simply press return.

## Develop a client side app

*tl;dr*

```
mkdir my-project
cd my-project
yo garlic-webapp
# Select garlictech scope (the default)
npm run setup-dev
npm run build
npm start
# See your web site in http://0.0.0.0:8081
```

All the client projects are based on Angular JS, webpack, karma, etc. The generated code takes care of them. Remark: the default generator (name without colon) generates an angular based client app.

### Start a client project

* Create a project directory. The directory naming must be in kebabcase (for example: _My Project_ should be in directory _my-project_) Enter the directory, then:

```bash
$ yo garlic-webapp [--skip-install]
```

After that, it scaffolds the webapp. If you do not specify `--skip-install`, then the generator will install npm and bower dependencies as well.

The generated code will utilize the [client side workflow package](https://github.com/garlictech/garlictech-workflows-client). When the installation of the dependencies 
are over, you should set up your development environment and start coding. So go to the [workflow doc](https://github.com/garlictech/garlictech-workflows-client) and continue.

## Develop a server project

*tl;dr*

```
mkdir my-project
cd my-project
yo garlic-webapp:server
# Select garlictech scope (the default), and a project name (default: the current directory name)
# Select the values that the loopback generator asks.
npm run setup-dev
npm run build
npm start
# See your server in http://0.0.0.0:3000
```

All the server projects are based on [loopback.io](http://loopback.io/), and the generated code is compatible with the [loopback generator](https://github.com/strongloop/generator-loopback).

### Start a server project

* Create a project directory. The directory naming must be in kebabcase (for example: _My Project_ should be in directory _my-project_) Enter the directory, then:

```bash
$ yo garlic-webapp:server [--skip-install]
```

* Type a scope or press return to select the default. The scope must be the organization id in github (so, for garlictech projects, it must be garlictech. You can see this ID in the URL of the github repos).
* Type the project name (in kebabcase) or accept the default that is calculated by the directory name.
* The loobpack generator starts. Answer its questions.

After that, the generator scaffolds the server. If you do not specify `--skip-install`, then the generator will install the npm dependencies as well.

The generated code will utilize the [server side workflow package](https://github.com/garlictech/garlictech-workflows-server). When the installation of the dependencies 
are over, you should set up your development environment and start coding. So go to the [workflow doc](https://github.com/garlictech/garlictech-workflows-server) and continue.
  
