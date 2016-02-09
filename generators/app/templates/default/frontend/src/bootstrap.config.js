'use strict';
// ## bootstrap-webpack Configuration
module.exports = {
  // ### Scripts
  // Any scripts here set to false will never
  // make it to the client, it's not packaged
  // by webpack.
  scripts: {
    'transition': false,
    'alert': false,
    'button': false,
    'carousel': false,
    'collapse': false,
    'dropdown': false,
    'modal': false,
    'tooltip': false,
    'popover': false,
    'scrollspy': false,
    'tab': false,
    'affix': false
  },
  // ### Styles
  // Enable or disable certain less components and thus remove
  // the css for them from the build.
  styles: {
    "mixins": false,

    "normalize": true,
    "print": false,

    "scaffolding": false,
    "type": false,
    "code": false,
    "grid": false,
    "tables": false,
    "forms": false,
    "buttons": false,

    "component-animations": false,
    "glyphicons": false,
    "dropdowns": false,
    "button-groups": false,
    "input-groups": false,
    "navs": false,
    "navbar": false,
    "breadcrumbs": false,
    "pagination": false,
    "pager": false,
    "labels": false,
    "badges": false,
    "jumbotron": false,
    "thumbnails": false,
    "alerts": false,
    "progress-bars": false,
    "media": false,
    "list-group": false,
    "panels": false,
    "wells": false,
    "close": false,

    "modals": false,
    "tooltip": false,
    "popovers": false,
    "carousel": false,

    "utilities": false,
    "responsive-utilities": false
  }
};