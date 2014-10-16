gulp = require 'gulp'
p = require('gulp-load-plugins')() # loading gulp plugins lazily
bowerFiles = require 'main-bower-files'
nib = require 'nib'
spawn = require('child_process').spawn
_ = require 'lodash'

node = null

files =
  coffeeFiles: ['**/*.coffee', '!**/node_modules/**', '!**/bower_components/**', '!gulpfile.coffee']
  coffeeFilesToWatch: ['frontend/**/*.coffee', 'backend/**/*.coffee', 'features/**/*.coffee', 'server.coffee']
  stylusFiles: ['frontend/**/*.styl']
  otherSources: ['**/*.jade', '!**/node_modules/**', '!**/bower_components/**']
  otherSourcesToWatch: ['frontend/**/*.jade']

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
gulp.task 'inject-bower', ->
  gulp.src bowerFiles()
  .pipe p.inject 'frontend/index.jade',
    starttag: '//---inject:bower:{{ext}}---'
    endtag: '//---inject---'
    transform: (filepath, file, index, length) ->
      filepath = filepath.replace /^.+?\//, '' #removes frontend/, .tmp/
      ext = filepath.split('.').pop()
      switch ext
        when 'css'
          "link(rel='stylesheet' href='#{filepath}')"
        when 'js'
          "script(src='#{filepath}')"
  .pipe gulp.dest 'frontend'

# =============================================================================
gulp.task 'inject-scripts', ['coffee', 'stylus'], ->
  gulp.src ['./.tmp/**/*'], read:false
  .pipe p.inject 'frontend/index.jade',
    starttag:'//---inject:{{ext}}---'
    endtag:'//---inject---'
    transform: (filepath, file, index, length) ->
      filepath = filepath.replace /^.+?\//, '' #removes frontend/, .tmp/
      ext = filepath.split('.').pop()
      switch ext
        when 'css'
          "link(rel='stylesheet' href='#{filepath}')"
        when 'js'
          "script(src='#{filepath}')"
  .pipe gulp.dest 'frontend'

# =============================================================================
gulp.task 'start-selenium', ->
  spawn 'node_modules/selenium-server/bin/selenium', [], stdio:'inherit'

# =============================================================================
executeBrowserTest = (testName) ->
  process.env.DRYWALL_TEST_BROWSER = testName;
  spawn './node_modules/.bin/cucumber.js', ['--format', 'summary', '--coffee', '-b'], stdio:'inherit'

_.each ['phantomjs', 'chrome', 'firefox'], (testName) ->
  gulp.task "test_#{testName}", (cb) ->
    executeBrowserTest(testName)

# =============================================================================
gulp.task 'build-dev', ['coffee', 'sources', 'uglify', 'stylus'], (cb) ->
  cb()

# =============================================================================
gulp.task 'watch-development', ['build-dev'], ->
  gulp.watch files.coffeeFilesToWatch, ['coffee']
  gulp.watch files.stylusFiles, ['stylus', 'csshint']
  gulp.watch files.otherSourcesToWatch, ['sources']

# =============================================================================
gulp.task 'watch-server', ['watch-development', 'livereload-start', 'start-server'], ->
  gulp.watch ['.tmp/server.js','.tmp/backend/**/*'], ['start-server']
  .on 'change', (file) ->
    p.livereload.changed file.path

# =============================================================================
gulp.task 'watch-frontend', ['watch-development', 'livereload-start'], ->
  gulp.watch ['.tmp/frontend/**/*']
    .on 'change', (file) ->
      p.livereload.changed file.path

# =============================================================================
gulp.task 'startServices', ['inject-bower', 'inject-scripts', 'watch-frontend',  'start-selenium'], (cb) ->
  cb()

# =============================================================================
gulp.task 'serve', ['startServices', 'watch-server'], ->
  p.util.log('Everything has been started!!!')

# =============================================================================
gulp.task 'start-server', ['coffee'], (cb) ->
  node.kill() if node
  node = spawn 'node', ['.tmp/server.js'], stdio:'inherit'
  node.on 'close', (code) ->
    if code is 8
      p.util.log 'Error! Waiting for changes'
  cb()

# =============================================================================
gulp.task 'build', ['jshint'], ->
  gulp.src 'dist/**/*'
  .pipe p.size {title: 'build', gzip: true}

# =============================================================================
gulp.task 'default', ['serve']
