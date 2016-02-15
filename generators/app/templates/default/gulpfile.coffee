gulp = require 'gulp'
gutil = require 'gutil'
p = require('gulp-load-plugins')() # loading gulp plugins lazily
_ = require 'lodash'
argv = require('yargs').argv

# -----------------------------------------------------------------------------
# Create representation of file/directory structure
backendRoot =  "backend/src"
commonRoot =  "common/src"
coffeeFiles = ["#{backendRoot}/**/*.coffee", "#{commonRoot}/**/*.coffee"]
jsFiles = ["#{backendRoot}/**/*.js", "#{commonRoot}/**/*.js", "#{backendRoot}/www"]
buildRoot =  "backend/bin"

handleError = (err) ->
  console.log err.toString()
  @emit 'end'

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
  GulpSrc coffeeFiles, 'coffee', {base: './'}
  .pipe p.coffeelint()
  .pipe p.coffeelint.reporter()
  .pipe p.coffee(bare:true).on 'error', (err)->p.util.log err;@emit 'end'
  .pipe gulp.dest buildRoot

# -----------------------------------------------------------------------------
gulp.task 'js', ->
  GulpSrc jsFiles, 'js', {base: './'}
  .pipe gulp.dest buildRoot

# -----------------------------------------------------------------------------
gulp.task 'watch', ['setup'], ->
  gulp.watch coffeeFiles, ['coffee', 'unittest']
  gulp.watch jsFiles, ['js', 'unittest']

# -----------------------------------------------------------------------------
gulp.task 'setup', ['js', 'coffee']

# -----------------------------------------------------------------------------
gulp.task 'unittest', ['setup'], ->
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
    .on 'error', handleError
    .once 'end', -> process.exit()

# -----------------------------------------------------------------------------
# Start the web server
gulp.task 'webserver', ->
  p.nodemon
    script: "#{backendRoot}/../bin/www"

# -----------------------------------------------------------------------------
gulp.task 'default', ['setup', 'watch', 'webserver']
