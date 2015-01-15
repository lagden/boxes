'use strict'

module.exports = (grunt) ->

  require('load-grunt-tasks')(grunt)
  require('time-grunt')(grunt)

  grunt.initConfig

    coffeelint:
      options:
        configFile: 'coffeelint.json'
      app: ['coffee/{,*/}*.coffee']

    coffee:
      compile:
        options:
          bare: true
        expand: true,
        flatten: false,
        cwd: 'coffee',
        src: ['{,*/}*.coffee'],
        dest: 'dev/js',
        ext: '.js'

    jade:
      html:
        options:
          pretty: true
        files: [
          expand: true
          flatten: false
          cwd: 'jade/html'
          src: [
            '{,*/}*.jade'
          ]
          dest: 'dev'
          ext: '.html'
        ]

      js:
        options:
          amd: true
          client: true
          namespace: false
        files: [
          expand: true
          flatten: false
          cwd: 'jade/js'
          src: [
            '{,*/}*.jade'
          ]
          dest: 'dev/js/templates'
          ext: '.js'
        ]

    sass:
      dev:
        options:
          style: 'expanded'
          compass: false
          noCache: true
          update: false
          unixNewlines: true
          trace: true
          sourcemap: 'none'
        files: [
          expand: true
          flatten: false
          cwd: 'sass'
          src: ['./*.sass']
          dest: 'tmp/css'
          ext: '.css'
        ]

    autoprefixer:
      options:
        browsers: ['last 1 version']
      files:
        expand: true
        flatten: false
        cwd: 'tmp/css'
        src: ['./*.css']
        dest: 'dev/css'
        ext: '.css'

    watch:
      script:
        files: ['coffee/{,*/}*.coffee']
        tasks: ['coffeelint', 'coffee']

      sass:
        files: ['sass/{,*/}*.sass']
        tasks: ['sass', 'autoprefixer']

      jade2html:
        files: ['jade/html/{,*/}*.jade']
        tasks: ['jade:html']

      jade2js:
        files: ['jade/js/{,*/}*.jade']
        tasks: ['jade:js']

    connect:
      dev:
        options:
          open: true
          port: 8284
          base: 'dev'

  grunt.registerTask 'default', [
    'coffeelint'
    'coffee'
    'jade'
    'sass'
    'autoprefixer'
  ]

  grunt.registerTask 'server', [
    'default'
    'connect'
    'watch'
  ]

  return
