# A [Yeoman](http://yeoman.io) generator to start a GarlicTech web app.

[![Build Status][build]][link]
[build]: https://travis-ci.org/garlictech/generator-garlic-webapp.svg?branch=master
[link]: https://travis-ci.org/garlictech/generator-garlic-webapp
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)
[![Commitizen friendly](https://img.shields.io/badge/commitizen-friendly-brightgreen.svg)](http://commitizen.github.io/cz-cli/)

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

When you use private Github and NPM repos, you have to specify some tokens to grant access to the resources. They are accessed via environment variables. In addition, you can work for several organizations in the same time, so you may have several scopes. This situation is handled by the following rules:

* Your personal github access token must be in the ```GITHUB_TOKEN``` environment variable.
* Your NPM token must be in environment variables like: ```NPM_TOKEN_Garlictech```:

 * Prefix: ```NPM_TOKEN```
 * Suffix: your scope in CamelCase.

Some of the generators may use ```NPM_TOKEN``` as well. If both token variables are set, then the more specific one (```NPM_TOKEN_Garlictech```) has priority.

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
\# Select garlictech scope (the default), and a project name (default: the current directory name)
\# Select the values that the loopback generator asks.
npm run setup-dev
npm run build
npm start
\# See your server in http://0.0.0.0:3000
\# ...then develop something, then:
git add .
npm run commit
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
  
## The generators

During the generator examples, we use MyOrganization az as example organization name. Mind, that the organization refers to the github organization, and must be in CamelCase. For example, if your organization is at
```http://github.com/my-organization```, then the label you should use everywhere is ```MyOrganization```.

## Generic generators

They work both on server and client sides.

### github

Creates and initializes a github repo for the project. It also configures Travis CI, and sets up the Slack notifications.

```
yo garlic-webapp:github
```

The organization is taken from the scope variable of ```.yo-rc.json```. Then, you have to add some tokens. The generator
can obtain those tokens from environment variables as well, it will offer them as defaults. The generation process will display those variable names.
Some variable names follow the convention in the docker-image section.

You can obtain the Slack webhook URL from the settings of any github repos (sending messages to the same Slack channel). As for Slack token, ask the admin of the organization.

Also, ask the development team id from the admin.

### docker-image

```
yo garlic-webapp:docker-image
```

Creates a docker image template in the ```docker-images``` folder. Also, creates organization-specific build scripts.

Before that, you have to set the following environment variables:

```
export NPM_TOKEN_MyOrganization=<your NPM token>
export DOCKER_USERNAME=<username for docker.my-organization.com docker repo>
export DOCKER_PASSWORD=<password for docker.my-organization.com docker repo>
```

Alternatively, you can set ```NPM_TOKEN``` instead of ```NPM_TOKEN_MyOrganization```. If both are set, ```NPM_TOKEN_MyOrganization``` has priority.

Do not forget to change labels in docker.my-organization.com, if your docker repo is in a different host.

**Known issues**

* If you changed ```scripts/build.sh``` (because, for example, your docker registry is not in the generated docker.my-organization.com), then do not allow the generator to overwrite this file. If you did, you have to re-implement your changes.

### docker-image

```
yo garlic-webapp:commitizen
```

We suggest using [commitizen](https://github.com/commitizen/cz-cli) during github commits. This generator prepares your project for this. The default generator also invokes this, by default. The actual commitizen packages are in the [workflows-common](https://github.com/garlictech/workflows/tree/master/workflows-common) docker image.

### semantic-release

```
yo garlic-webapp:semantic-release
```

We suggest using [semantic release](https://github.com/semantic-release/semantic-release) for travis ci-based automated releasing and labeling. This generator prepares your project for this. The default generator also invokes this, by default. The actual semantic-release packages are in the [workflows-common](https://github.com/garlictech/workflows/tree/master/workflows-common) docker image.
