### global define ###

'use strict'

define [
    'TweenMax'
    'jquery'
  ], (TM, $) ->

  class WhatIsMatrix
    constructor: (container, options) ->
      @container = $ container
      @itens = @container.find '> .item'
      # @itens.css 'position': 'absolute'

    redPill: (i) ->
      @itens[i].style.position = 'absolute'
      @itens[i].style.backgroundColor = 'green'
      TM.to @itens[i], 2,
        transformPerspective: 600
        x: 50 #parseInt (Math.random() * 1000), 10
        y: 0 #parseInt (Math.random() * 1000), 10
        z: 0

  return WhatIsMatrix
