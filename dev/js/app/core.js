
/* global define */
'use strict';
define(['app/matrix', 'app/original', 'jquery'], function(WhatIsMatrix, Placer, $) {
  var $container, PlacerData, dataArrayExample, i, itens, placer, _i, _len;
  PlacerData = (function() {
    function PlacerData(content, unitWidth, unitHeight) {
      this.content = content;
      this.unitWidth = unitWidth;
      this.unitHeight = unitHeight;
    }

    return PlacerData;

  })();
  $container = $('.list');
  dataArrayExample = [];
  itens = $('.item');
  for (_i = 0, _len = itens.length; _i < _len; _i++) {
    i = itens[_i];
    dataArrayExample.push(new PlacerData(i.outerHTML, 1, 1));
    $container[0].removeChild(i);
  }
  placer = new Placer($container[0], 100, 4, dataArrayExample, 30);
});
