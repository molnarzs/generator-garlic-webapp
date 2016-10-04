# A [Yeoman](http://yeoman.io) generator to start a GarlicTech web app.

[![Build Status](https://travis-ci.org/garlictech/generator-garlic-webapp.svg?branch=master)](https://travis-ci.org/garlictech/generator-garlic-webapp)

## Getting Started

### Prerequistes

The [Yeoman generator](http://yeoman.io) and the [loopback generator](https://github.com/strongloop/generator-loopback) must be installed:

```bash
$ sudo npm install -g yo generator-loopback
```

### Setup
To install the generator-garlic-webapp, run:

```bash
$ sudo npm install -g generator-garlic-webapp
```

The generator has some peer dependencies. If they are missing (for instance, the [loopback.io generator](https://github.com/strongloop/generator-loopback)), you must also install them globally. The above install
command will warn you and list the missing software in this case.

## Environment variables

When you use private Github and NPM repos, you have to specify some tokens to grant access to the resources. They are done via environment variables. In addition, you can work for several organizations in the same time, so you may have several scopes. This situation is handled by the following rules:

* Your personal github access token must be in the ```GITHUB_TOKEN``` environment variable.
* Your NPM token must be in environment variables like: ```NPM_TOKEN_Garlictech```:

 * Prefix: ```NPM_TOKEN```
 * Suffix: your scope in CamelCase.

# The Generators

## General remarks

* Some of the generators ask for scope. The scope must be the organization id in github (so, for garlictech projects, it must be garlictech). You can see this ID in the URL of the github repos.
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
# 
```

[Your web site](http://localhost:8081) is: http://localhost:8081.


### Start a client project

All the client projects are based on Angular JS, plus some dockerized software (webpack, karma, protractor).

* Create a project directory. The directory naming must be in kebabcase (for example: _My Project_ should be in directory _my-project_) Enter the directory, then:

```bash
$ yo garlic-webapp
```
* Type a scope or press return to select the default. The scope must be the organization id in github (so, for garlictech projects, it must be garlictech. You can see this ID in the URL of the github repos).
* Select project type.
 * ```module```: the project is an AngularJS module. There is no ```index.html```, therefore the generator creates a "site" for you that you can use during the development as some kind of sandbox. ```npm start``` will use this site.
 * ```site```: A regular, AngularJS based site. In this case, ```index.html``` will be generated in the ```src``` folder, as the entry point of your site.
* Confirm if you want to create a Github repo for the project. If you reply yes, the github/travis generator starts.

After that, it scaffolds the webapp.

The generated code will utilize the Docker based [client side workflow package](https://github.com/garlictech/docker-images). Go there for more information about how to develop your site/module.

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
$ yo garlic-webapp:server
```

* Type a scope or press return to select the default. The scope must be the organization id in github (so, for garlictech projects, it must be garlictech. You can see this ID in the URL of the github repos).
* Type the project name (in kebabcase) or accept the default that is calculated by the directory name.
* The loobpack generator starts. Answer its questions.

After that, the generator scaffolds the server. If you do not specify `--skip-install`, then the generator will install the npm dependencies as well.

The generated code will utilize the [server side workflow package](https://github.com/garlictech/garlictech-workflows-server). When the installation of the dependencies 
are over, you should set up your development environment and start coding. So go to the [workflow doc](https://github.com/garlictech/garlictech-workflows-server) and continue.
  
