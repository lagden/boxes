
/* global define */
'use strict';
define([], function() {
  var ContentPlacer;
  ContentPlacer = (function() {
    function ContentPlacer(target, unitSize, margin, dataArray, renderDelay) {
      var boundHandler, handler;
      if (typeof target === "string") {
        this.target = document.getElementById(target);
      } else {
        this.target = target;
      }
      this.unitSize = unitSize;
      this.margin = margin;
      this.data = dataArray;
      this.rowsTot = 1;
      this.initiated = false;
      this.largestElement = 1;
      this.renderDelay = renderDelay;
      this.itteration = 0;
      this.elemCache = [];
      this.findLargestNode_();
      this.calculateColumns_();
      handler = function() {
        var newCols;
        if (this.data.length > 0) {
          newCols = Math.max(Math.floor(this.target.offsetWidth / (this.unitSize + this.margin)), this.largestElement);
          if (newCols !== this.columns) {
            this.rowsTot = 1;
            this.columns = newCols;
            this.render_();
          }
        }
      };
      boundHandler = handler.bind(this);
      this.addEventHandler_(window, "resize", boundHandler);
      this.render_();
      return;
    }


    /**
    @private
     */

    ContentPlacer.prototype.calculateColumns_ = function() {
      this.columns = Math.max(Math.floor(this.target.offsetWidth / (this.unitSize + this.margin)), this.largestElement);
    };


    /**
    @private
     */

    ContentPlacer.prototype.findLargestNode_ = function() {
      var i;
      i = this.data.length;
      while (i--) {
        if (this.data[i].width > this.largestElement) {
          this.largestElement = this.data[i].width;
        }
      }
    };


    /**
    @private
     */

    ContentPlacer.prototype.matrix_ = function(numrows, numcols, initial) {
      var arr, columns, x, y;
      arr = [];
      y = 0;
      while (y < numrows) {
        columns = [];
        x = 0;
        while (x < numcols) {
          columns.push(initial);
          x++;
        }
        arr.push(columns);
        y++;
      }
      return arr;
    };


    /**
    @private
     */

    ContentPlacer.prototype.growMatrix_ = function(arr, numrows, initial) {
      var columns, x, y;
      y = 0;
      while (y < numrows) {
        columns = [];
        x = 0;
        while (x < this.columns) {
          columns.push(initial);
          x++;
        }
        arr.push(columns);
        y++;
      }
      return arr;
    };


    /**
    Attach desired event handler. Cross browser.
     */

    ContentPlacer.prototype.addEventHandler_ = function(elem, eventType, handler) {
      if (elem.addEventListener) {
        elem.addEventListener(eventType, handler, false);
      } else {
        if (elem.attachEvent) {
          elem.attachEvent("on" + eventType, handler);
        }
      }
    };


    /**
    @private
     */

    ContentPlacer.prototype.generatePosition_ = function(dataMatrix, unitWidth, unitHeight) {
      var allGood, cols, foundSpot, j, k, left, printArray, rows, top, x, y;
      printArray = function(arr) {
        var cols, j, k, rows, str;
        str = "";
        cols = arr[0].length;
        rows = arr.length;
        k = 0;
        while (k < rows) {
          j = 0;
          while (j < cols) {
            str += arr[k][j];
            j++;
          }
          str += "\n";
          k++;
        }
        console.log(str);
      };
      top = 0;
      left = 0;
      x = 0;
      y = 0;
      cols = dataMatrix[x].length;
      rows = dataMatrix.length;
      foundSpot = false;
      if (unitWidth > this.largestElement) {
        this.largestElement = unitWidth;
      }
      while (y < rows) {
        x = 0;
        while (x < cols) {
          if (dataMatrix[y][x] === 0) {
            allGood = true;
            if ((x + unitWidth - 1) >= cols) {
              allGood = false;
            }
            if ((y + unitHeight - 1) >= rows) {
              allGood = false;
            }
            if (allGood) {
              j = 0;
              while (j < unitWidth) {
                k = 0;
                while (k < unitHeight) {
                  if (dataMatrix[y + k][x + j] !== 0) {
                    allGood = false;
                    break;
                  }
                  k++;
                }
                if (!allGood) {
                  break;
                }
                j++;
              }
            }
            if (allGood) {
              foundSpot = true;
              left = x * (this.unitSize + this.margin);
              top = y * (this.unitSize + this.margin);
              if ((y + unitHeight) > this.rowsTot) {
                this.rowsTot = y + unitHeight;
              }
              j = 0;
              while (j < unitWidth) {
                k = 0;
                while (k < unitHeight) {
                  dataMatrix[y + k][x + j] = 1;
                  k++;
                }
                j++;
              }
              break;
            }
          }
          x++;
        }
        if (foundSpot) {
          break;
        }
        y++;
      }
      if (foundSpot) {
        return {
          top: top,
          left: left
        };
      } else {
        this.growMatrix_(dataMatrix, Math.ceil(dataMatrix.length / 2), 0);
        return this.generatePosition_(dataMatrix, unitWidth, unitHeight);
      }
    };


    /**
    @private
     */

    ContentPlacer.prototype.render_ = function() {
      var container, data, dataMatrix, div, frag, itterativeRender, n, pos, rHeight, unitSize;
      data = this.data;
      dataMatrix = this.matrix_(this.rowsTot, this.columns, 0);
      unitSize = this.unitSize;
      if (!this.initiated) {
        itterativeRender = function() {
          if (this.renderDelay !== undefined) {
            this.elemCache[this.itteration].setAttribute("class", "contentPlacerElement transition");
          } else {
            this.elemCache[this.itteration].setAttribute("class", "contentPlacerElement");
          }
          this.itteration++;
          if (this.itteration < this.elemCache.length) {
            setTimeout(itterativeRender.bind(this), this.renderDelay);
          }
        };
        frag = document.createDocumentFragment();
        n = 0;
        while (n < data.length) {
          pos = this.generatePosition_(dataMatrix, data[n].width, data[n].height);
          div = document.createElement("div");
          div.className = "contentPlacerElement";
          if (this.renderDelay !== undefined) {
            div.className += " hidden transition";
          }
          div.style.width = ((data[n].width * unitSize) + ((data[n].width - 1) * this.margin)) + "px";
          div.style.height = ((data[n].height * unitSize) + ((data[n].height - 1) * this.margin)) + "px";
          div.style.top = pos.top + "px";
          div.style.left = pos.left + "px";
          div.innerHTML = data[n].content;
          frag.appendChild(div);
          n++;
        }
        rHeight = (this.rowsTot * unitSize) + ((this.rowsTot - 1) * this.margin);
        container = document.createElement("div");
        container.className = "contentPlacerContainer";
        container.style.height = rHeight + "px";
        container.appendChild(frag);
        this.target.appendChild(container);
        this.target.style.height = rHeight + "px";
        this.target.style.minWidth = ((unitSize + this.margin) * this.largestElement) + "px";
        this.elemCache = document.getElementsByClassName("contentPlacerElement");
        if (this.renderDelay !== undefined) {
          this.itteration = 0;
          setTimeout(itterativeRender.bind(this), 5);
        }
        this.initiated = true;
      } else {
        n = 0;
        while (n < data.length) {
          pos = this.generatePosition_(dataMatrix, data[n].width, data[n].height);
          this.elemCache[n].style.top = pos.top + "px";
          this.elemCache[n].style.left = pos.left + "px";
          this.elemCache[n].style.width = ((data[n].width * unitSize) + ((data[n].width - 1) * this.margin)) + "px";
          this.elemCache[n].style.height = ((data[n].height * unitSize) + ((data[n].height - 1) * this.margin)) + "px";
          n++;
        }
        rHeight = (this.rowsTot * unitSize) + ((this.rowsTot - 1) * this.margin);
        this.target.style.height = rHeight + "px";
        this.target.children.item(0).style.height = rHeight + "px";
      }
    };


    /**
    Set a new margin size.
     */

    ContentPlacer.prototype.setMargin = function(marginSizePx) {
      this.margin = marginSizePx;
      this.columns = Math.max(Math.floor(this.target.offsetWidth / (this.unitSize + this.margin)), this.largestElement);
      this.render_();
    };


    /**
    Set a new default unit size.
     */

    ContentPlacer.prototype.setUnitSize = function(size) {
      this.unitSize = size;
      this.columns = Math.max(Math.floor(this.target.offsetWidth / (this.unitSize + this.margin)), this.largestElement);
      this.render_();
    };


    /**
    Set new data to use, overwrites existing.
    @param {Array.<Object>} dataArray An array containing data we wish to use.
     */

    ContentPlacer.prototype.setData = function(dataArr) {
      this.data = dataArr;
      this.findLargestNode_();
      this.calculateColumns_();
      this.target.innerHTML = "";
      this.initiated = false;
      this.render_();
    };


    /**
    Add new data to use, appends to existing.
    @param {Array.<Object>} dataArray An array containing data we wish to add.
     */

    ContentPlacer.prototype.addData = function(dataArr) {
      this.data = this.data.concat(dataArr);
      this.findLargestNode_();
      this.calculateColumns_();
      this.target.innerHTML = "";
      this.initiated = false;
      this.render_();
    };


    /**
    Set a new transition delay.
     */

    ContentPlacer.prototype.setDelay = function(delayMs) {
      this.renderDelay = delayMs;
    };

    return ContentPlacer;

  })();
  return ContentPlacer;
});
