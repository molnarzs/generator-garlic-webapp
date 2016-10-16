# <%= conf.appNameAsIs %>

[![Build Status](get travis link here)
[![Commitizen friendly](https://img.shields.io/badge/commitizen-friendly-brightgreen.svg)](http://commitizen.github.io/cz-cli/)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)

## Development

We use the [Docker based GarlicTech workflow manager](https://github.com/garlictech/workflows) to control development, build, deployment. 
See the appropriate sections there, It is * important *. For the description of `npm run`, `make`, etc. commands, consult the page.

Here, we summarize the most important points.

### Set up the development environment

After cloning a repo:

```
npm run setup-dev
```

It creates the default `.env` file that you can customize.

### .env file

It sets the following environment variables:

* `NODE_ENV`

Default: `development`. In this case, the `npm run unittest` command does not exit, it watches file changes.
