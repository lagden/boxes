### global define, requirejs ###

'use strict'

define 'config', ->

  requirejs.config
    baseUrl: 'js/lib'
    paths:
      app: '../app'
      TweenMax: './gsap/src/uncompressed/TweenMax'
      ScrollToPlugin: './gsap/src/uncompressed/plugins/ScrollToPlugin'

  return
