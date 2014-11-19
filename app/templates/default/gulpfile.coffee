gulp = require 'gulp'
p = require('gulp-load-plugins')() # loading gulp plugins lazily
bowerFiles = require 'main-bower-files'
nib = require 'nib'
spawn = require('child_process').spawn
_ = require 'lodash'
fs = require 'fs'

node = null

files =
  coffeeFiles: ['**/*.coffee', '!**/node_modules/**', '!**/bower_components/**', '!gulpfile.coffee']
  coffeeFilesToWatch: ['frontend/**/*.coffee', 'backend/**/*.coffee', 'features/**/*.coffee', 'server.coffee']
  stylusFiles: ['frontend/**/*.styl']
  otherSources: ['**/*.jade', '**/templates/vendor/**', '!**/node_modules/**', '!**/bower_components/**']
  otherSourcesToWatch: ['frontend/**/*.jade']

logfiles =
  mongodLog: 'logs/mongod.log'
  garlicUserLog: 'logs/garlicUser.log'
  garlicUserErrorLog: 'logs/garlicUser.err.log'

# =============================================================================
mySpawn = (command, args) ->
  handler = (data) ->
    p.util.log data.toString()

  child = spawn command, args
  child.stdout.on 'data', handler
  child.stderr.on 'data', handler
  return child

# =============================================================================
gulp.task 'jshint', ->
  gulp
    .src(['./.tmp/**/*.js'])
    .pipe p.jshint()
    .pipe p.using {}
    .pipe p.jshint.reporter('jshint-stylish')
    .pipe p.jshint.reporter('fail')

# =============================================================================
gulp.task 'sources', ->
  gulp
    .src(files.otherSources)
    .pipe p.cached 'sources'
    .pipe p.using {}
    .pipe gulp.dest './.tmp'

# =============================================================================
gulp.task 'coffee', ->
  return gulp
    .src files.coffeeFiles
    .pipe p.cached('coffee')
    .pipe p.using {}
    .pipe p.coffee(bare:true).on 'error', (err)->p.util.log err;@emit 'end'
    .pipe p.jshint()
    .pipe p.jshint.reporter('jshint-stylish')
    .pipe gulp.dest '.tmp'

# =============================================================================
gulp.task 'uglify', ['coffee'], ->
  gulp
    .src ['./.tmp/frontend/**/*.js', '!./.tmp/frontend/**/*.min.js']
    .pipe p.cached 'uglify'
    .pipe p.using {}
    .pipe p.sourcemaps.init()
    .pipe p.uglify()
    .pipe p.concat 'scripts.min.js'
    .pipe p.sourcemaps.write('./')
    .pipe gulp.dest 'dist/frontend'

# =============================================================================
gulp.task 'stylus', ->
  gulp
    .src files.stylusFiles
    .pipe p.cached 'stylus'
    .pipe p.using {}
    .pipe p.stylus(use:[nib()]).on 'error', (err)->p.util.log "Stylus Error:\n#{err.message}";@emit 'end'
    .pipe gulp.dest './.tmp/frontend'

# =============================================================================
gulp.task 'csslint', ->
  gulp
    .src(['./.tmp/**/*.css'])
    .pipe p.csslint()
    .pipe p.using {}
    .pipe p.csslint.reporter('jshint-stylish')
    .pipe p.csslint.reporter('fail')

# =============================================================================
gulp.task 'livereload-start', ->
  p.livereload.listen()

# =============================================================================
gulp.task 'inject-scripts', ['coffee', 'stylus'], ->
  gulp.src ['./.tmp/frontend/**/*', '!./.tmp/frontend/templates/vendor/**/*'].concat(bowerFiles()), read:false
  .pipe p.inject 'frontend/templates/layouts/global.jade',
    starttag:'//---inject:{{ext}}---'
    endtag:'//---inject---'
    transform: (filepath, file, index, length) ->
      filepath = filepath.replace /^.+?\//, '' #removes .tmp/, etc.
      filepath = filepath.replace "frontend/", '' #removes frontend/
      ext = filepath.split('.').pop()
      switch ext
        when 'css'
          "link(rel='stylesheet' href='#{filepath}')"
        when 'js'
          "script(src='#{filepath}')"
  .pipe gulp.dest './.tmp/frontend/templates/layouts/'

# =============================================================================
gulp.task 'start-selenium', ->
  spawn 'node_modules/selenium-server/bin/selenium', [], stdio:'inherit'

# =============================================================================
executeBrowserTest = (testName) ->
  process.env.DRYWALL_TEST_BROWSER = testName;
  spawn './node_modules/.bin/cucumber.js', ['--format', 'summary', '--coffee', '-b'], {
    stdio:'inherit'
  }

_.each ['phantomjs', 'chrome', 'firefox'], (testName) ->
  gulp.task "test_#{testName}", (cb) ->
    executeBrowserTest(testName)

# =============================================================================
gulp.task 'build-dev', ['coffee', 'sources', 'uglify', 'stylus'], (cb) ->
  cb()

# =============================================================================
gulp.task 'watch-development', ['build-dev'], ->
  gulp.watch files.coffeeFilesToWatch, ['coffee']
  gulp.watch files.stylusFiles, ['stylus', 'csslint']
  gulp.watch files.otherSourcesToWatch, ['sources']
  gulp.watch ['./frontend/templates/layouts/global.jade'], ['inject-scripts']

# =============================================================================
gulp.task 'watch-server', ['livereload-start', 'start-server'], ->
  gulp.watch ['.tmp/server.js','.tmp/backend/**/*'], ['start-server']
  .on 'change', (file) ->
    p.livereload.changed file.path

# =============================================================================
gulp.task 'watch-frontend', ['livereload-start'], ->
  gulp.watch ['.tmp/frontend/**/*']
    .on 'change', (file) ->
      p.livereload.changed file.path

# =============================================================================
gulp.task 'startServices', ['inject-scripts', 'watch-frontend', 'watch-development', 'start-selenium'], (cb) ->
  cb()

# =============================================================================
gulp.task 'serve', ['startServices', 'watch-server'], ->
  p.util.log('Everything has been started!!!')

# =============================================================================
gulp.task 'start-server', ['coffee', 'start-mongod', 'start-garlic-user'], (cb) ->
  node.kill() if node
  node = mySpawn 'node', ['.tmp/server.js']

  node.on 'close', (code) ->
    if code is 8
      p.util.log 'Error! Waiting for changes'
  cb()

# =============================================================================
gulp.task 'build', ['jshint'], ->
  gulp.src 'dist/**/*'
  .pipe p.size {title: 'build', gzip: true}

# =============================================================================
gulp.task 'start-mongod', ->
  spawn 'mongod', ['--logpath', logfiles.mongodLog, '--logappend'], stdio:'inherit'
  p.util.log p.util.colors.yellow '>>> Mongod has been started, log:', p.util.colors.magenta logfiles.mongodLog

# =============================================================================
gulp.task 'start-garlic-user', ['start-mongod'], ->
  out = fs.openSync(logfiles.garlicUserLog, 'a')
  err = fs.openSync(logfiles.garlicUserErrorLog, 'a')

  spawn 'node', ['app.js'], {
    cwd: 'node_modules/garlic-user/'
    stdio: ['ignore', out, err]
  }

  p.util.log p.util.colors.yellow '>>> garlic-user has been started, log files:', p.util.colors.magenta logfiles.garlicUserLog, ', ', logfiles.garlicUserErrorLog

# =============================================================================
gulp.task 'default', ['serve']
