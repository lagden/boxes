### global define ###

'use strict'

define [
    'app/matrix'
    'app/original'
    'jquery'
  ], (WhatIsMatrix, Placer, $) ->

  neo = new WhatIsMatrix '.container'
  neo.redPill u for u in [0..19]

  # setInterval ->
  #   neo.redPill u for u in [0..19]
  # , 3000

  # class PlacerData
  #   constructor: (@content, @unitWidth, @unitHeight) ->

  # $container = $('.list')

  # dataArrayExample = []
  # itens = $ '.item'
  # for i in itens
  #   dataArrayExample.push new PlacerData(i.outerHTML, 1 ,1)
  #   $container[0].removeChild i

  # placer = new Placer $container[0], 100, 4, dataArrayExample, 30

  return
