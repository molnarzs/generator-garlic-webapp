gulp = require 'gulp'
p = require('gulp-load-plugins')() # loading gulp plugins lazily
gutil = require 'gulp-util'

coffeeFiles = ['src/generators/**/index.coffee']

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
  GulpSrc coffeeFiles, 'coffee', {base: './src/generators'}
  .pipe p.coffeelint()
  .pipe p.coffeelint.reporter()
  .pipe p.coffee(bare:true).on 'error', (err)->p.util.log err;@emit 'end'
  .pipe gulp.dest './generators'


# -----------------------------------------------------------------------------
# watch...
gulp.task 'watch', ->
  gulp.watch coffeeFiles, ['coffee']

gulp.task 'default', ['coffee', 'watch'], ->
