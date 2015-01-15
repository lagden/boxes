
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
      TM.set(this.itens[i], {
        transformPerspective: 600
      });
      TM.to(this.itens[i], 2, {
        x: parseInt(Math.random() * 1000, 10),
        y: parseInt(Math.random() * 1000, 10),
        z: 0
      });
    };

    return WhatIsMatrix;

  })();
  return WhatIsMatrix;
});
