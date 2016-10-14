# <%= conf.appNameAsIs %>

[![Build Status](get travis link here)

## Development

We use the [Docker based GarlicTech workflow manager](https://github.com/garlictech/workflows) to control development, build, deployment. 
See the appropriate sections there, It is * important *. For the description of `npm run` commands, etc.

Here, we summarize the mos important points.

### Set up the development environment

After cloning a repo:

```
npm run setup-dev
```

It creates the default `.env` file.


### .env file

It sets the following environment variables:

* `NODE_ENV`

Default: `development`. In this case, the `npm run unittest` command does not exit, it watches file changes.

* `PORT`

The port where the local server is mapped. The mapping is done in one of the docker-compose files. Defaulr: 8081. Mind, that inside the container, all the (dev) web servers
are bound to port 8081, and docker compose maps this port to the value defined in `PORT`.

