# <%= conf.appNameAsIs %>

[![Build Status](get travis link here)

## Development

We use the [Docker based GarlicTech workflow manager](https://github.com/garlictech/workflows) to control development, build, deployment. 
See the appropriate sections there, It is * important *. For the description of `npm run`, `make`, etc. commands, consult the page.

*Warning*: the `npm run build:dev` command adds the supported Angular 2 packages to `package.json`. If current dependency versions are different, then they are overwritten. Comment out the line responsible for it
in `docker/build-dev.sh` script if you don't want this behavior. If you want to experiment with different angular package versions, then check out teh appropriate workflow 
module(s) and have fun.

