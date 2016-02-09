gulp = require 'gulp'
gutil = require 'gutil'
p = require('gulp-load-plugins')() # loading gulp plugins lazily
_ = require 'lodash'
argv = require('yargs').argv

# -----------------------------------------------------------------------------
# Create representation of file/directory structure
backendRoot =  "backend/src"
commonRoot =  "common/src"
buildRoot =  "backend/bin"

# -----------------------------------------------------------------------------
# Create a gulp task, and orchestrate it with default functions
GulpSrc = (srcFiles, taskName, srcOptions = {}) ->
  gulp.src srcFiles, srcOptions
  .pipe p.cached taskName
  .pipe p.using {}
  .pipe p.size()

# -----------------------------------------------------------------------------
# handle src coffeescript files: static compilation
gulp.task 'coffee', ->
  GulpSrc "#{backendRoot}/**/*.coffee", 'coffee', {base: backendRoot}
  .pipe p.coffeelint()
  .pipe p.coffeelint.reporter()
  .pipe p.coffee(bare:true).on 'error', (err)->p.util.log err;@emit 'end'
  .pipe gulp.dest buildRoot

# -----------------------------------------------------------------------------
gulp.task 'js', ->
  GulpSrc ["#{backendRoot}/**/*.js", "#{backendRoot}/www"], 'js', {base: backendRoot}
  .pipe gulp.dest buildRoot

# -----------------------------------------------------------------------------
gulp.task 'watch', ['setup'], ->
  gulp.watch "#{backendRoot}/**/*.coffee", ['coffee', 'unittest']
  gulp.watch "#{backendRoot}/**/*.js", ['js', 'unittest']

# -----------------------------------------------------------------------------
gulp.task 'setup', ['js', 'coffee']

# -----------------------------------------------------------------------------
gulp.task 'unittest', ->
    gulp.src ["#{backendRoot}/test/unittest/index.coffee", "#{backendRoot}/**/*unit-tests.coffee", "#{commonRoot}/**/*unit-tests.coffee"], {read: false}
    .pipe p.coffee({bare: true}).on('error', gutil.log)
    .pipe p.mocha
      reporter: 'spec'
      ui: 'bdd'
      recursive: true

# -----------------------------------------------------------------------------
gulp.task 'systemtest', ['setup'], ->
  gulp.src ["#{backendRoot}/test/systemtest/index.coffee", "#{backendRoot}/**/*system-tests.coffee", "#{commonRoot}/**/*system-tests.coffee"], {read: false}
    .pipe p.coffee({bare: true}).on('error', gutil.log)
    .pipe p.mocha
      reporter: 'spec'
      ui: 'bdd'
      recursive: true
    .once 'error', -> process.exit 1
    .once 'end', -> process.exit()

# -----------------------------------------------------------------------------
# Start the web server
gulp.task 'webserver', ->
  p.nodemon
    script: "#{backendRoot}/../bin/www"

# -----------------------------------------------------------------------------
gulp.task 'default', ['setup', 'watch', 'webserver']
