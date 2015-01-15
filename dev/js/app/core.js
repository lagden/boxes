
/* global define */
'use strict';
define(['app/matrix', 'app/original', 'jquery'], function(WhatIsMatrix, Placer, $) {
  var neo, u, _i;
  neo = new WhatIsMatrix('.container');
  for (u = _i = 0; _i <= 19; u = ++_i) {
    neo.redPill(u);
  }
});
