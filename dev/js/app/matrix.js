
/* global define */
'use strict';
define(['TweenMax', 'jquery'], function(TM, $) {
  var WhatIsMatrix;
  WhatIsMatrix = (function() {
    function WhatIsMatrix(container, options) {
      this.container = $(container);
      this.itens = this.container.find('> .item');
    }

    WhatIsMatrix.prototype.redPill = function(i) {
      this.itens[i].style.position = 'absolute';
      this.itens[i].style.backgroundColor = 'green';
      return TM.to(this.itens[i], 2, {
        transformPerspective: 600,
        x: 50,
        y: 0,
        z: 0
      });
    };

    return WhatIsMatrix;

  })();
  return WhatIsMatrix;
});
