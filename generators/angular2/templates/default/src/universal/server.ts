// These are important and needed before anything else
import 'zone.js/dist/zone-node';
import 'reflect-metadata';

import { enableProdMode } from '@angular/core';
import { renderModuleFactory } from '@angular/platform-server';

import * as express from 'express';
import { join } from 'path';
import { readFileSync } from 'fs';

import 'localstorage-polyfill';

const DIST_FOLDER = join(process.cwd(), 'artifacts', 'dist');

// Add domino
const template = readFileSync(join(DIST_FOLDER, 'browser', 'index.html')).toString();

const domino = require('domino');
const win = domino.createWindow(template);

win.devicePixelRatio = 1;

global['window'] = win;
global['document'] = win.document;
global['localStorage'] = localStorage;
global['DOMTokenList'] = win.DOMTokenList;
global['Node'] = win.Node;
global['Text'] = win.Text;
global['HTMLElement'] = win.HTMLElement;
global['navigator'] = win.navigator;
global['Event'] = win.Event;
global['KeyboardEvent'] = win.KeyboardEvent;
global['MouseEvent'] = win.MouseEvent;
global['URL'] = win.URL;

console.log(URL);

win.localStorage = localStorage;

win.L = require('leaflet');

global['L'] = win.L;

// Faster server renders w/ Prod mode (dev mode never needed)
enableProdMode();

// Express server
const app = express();

const PORT = process.env.PORT || 4000;

// * NOTE :: leave this as require() since this file is built Dynamically from webpack
const { AppServerModuleNgFactory, LAZY_MODULE_MAP } = require('../artifacts/dist/server/main');

// Express Engine
import { ngExpressEngine } from '@nguniversal/express-engine';
// Import module map for lazy loading
import { provideModuleMap } from '@nguniversal/module-map-ngfactory-loader';

app.engine('html', (_, options, callback) => {
  renderModuleFactory(AppServerModuleNgFactory, {
    // Our index.html
    document: template,
    url: options.req.url,
    // DI so that we can get lazy-loading to work differently (since we need it to just instantly render it)
    extraProviders: [provideModuleMap(LAZY_MODULE_MAP)]
  }).then(html => {
    callback(null, html);
  });
});

app.set('view engine', 'html');
app.set('views', join(DIST_FOLDER, 'browser'));

// TODO: implement data requests securely
app.get('/api/*', (req, res) => {
  res.status(404).send('data requests are not supported');
});

// Server static files from /browser
app.get('*.*', express.static(join(DIST_FOLDER, 'browser')));

// All regular routes use the Universal engine
app.get('*', (req, res) => {
  res.render('index', { req });
});

// Start up the Node server
app.listen(PORT, () => {
  console.log(`Node server listening on http://localhost:${PORT}`);
});
