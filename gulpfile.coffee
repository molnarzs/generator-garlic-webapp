gulp = require 'gulp'
changed = require 'gulp-changed'
coffee = require 'gulp-coffee'
gutil = require 'gulp-util'

coffeeFiles = ['app/index.coffee']

gulp.task 'coffee', ->
  gulp
  .src coffeeFiles, {base: './'}
  .pipe changed './.tmp', extension:'.js'
  .pipe coffee(bare:true).on 'error', (err)->gutil.log err;@emit 'end'
  .pipe gulp.dest '.'

gulp.task 'watch', ->
  gulp.watch coffeeFiles, ['coffee']

gulp.task 'default', ['coffee', 'watch'], ->
