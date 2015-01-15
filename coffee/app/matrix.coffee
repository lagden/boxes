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

    redPill: (i) ->
      @itens[i].style.position = 'absolute'
      @itens[i].style.backgroundColor = 'green'

      TM.set @itens[i],
        transformPerspective: 600

      TM.to @itens[i], 2,
        x: parseInt (Math.random() * 1000), 10
        y: parseInt (Math.random() * 1000), 10
        z: 0

      return

  return WhatIsMatrix
