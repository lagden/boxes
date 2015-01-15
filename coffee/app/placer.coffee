### global define ###

'use strict'

define [], ->

  class ContentPlacer
    constructor: (target, unitSize, margin, dataArray, renderDelay) ->
      if typeof target is "string"
        @target = document.getElementById(target)
      else @target = target

      @unitSize = unitSize
      @margin = margin
      @data = dataArray
      @rowsTot = 1
      @initiated = false
      @largestElement = 1

      # Variables to do with animation.
      @renderDelay = renderDelay
      @itteration = 0
      @elemCache = []

      # Figure out the minimum number of cols by respecting the width of
      # largest element.
      @findLargestNode_()
      @calculateColumns_()
      handler = ->
        if @data.length > 0
          newCols = Math.max(
            Math.floor(@target.offsetWidth / (@unitSize + @margin)),
            @largestElement
          )
          unless newCols is @columns
            @rowsTot = 1
            @columns = newCols
            @render_()
        return

      boundHandler = handler.bind(this)
      @addEventHandler_ window, "resize", boundHandler
      @render_()
      return

    ###*
    @private
    ###
    calculateColumns_: ->
      @columns = Math.max(
        Math.floor(@target.offsetWidth / (@unitSize + @margin)), @largestElement
      )
      return


    ###*
    @private
    ###
    findLargestNode_: ->
      i = @data.length
      while i--
        @largestElement = @data[i].width if @data[i].width > @largestElement
      return


    ###*
    @private
    ###
    matrix_: (numrows, numcols, initial) ->
      arr = []
      y = 0

      while y < numrows
        columns = []
        x = 0

        while x < numcols
          columns.push initial
          x++
        arr.push columns
        y++
      arr


    ###*
    @private
    ###
    growMatrix_: (arr, numrows, initial) ->
      y = 0

      while y < numrows
        columns = []
        x = 0

        while x < @columns
          columns.push initial
          x++
        arr.push columns
        y++
      arr


    ###*
    Attach desired event handler. Cross browser.
    ###
    addEventHandler_: (elem, eventType, handler) ->
      if elem.addEventListener
        elem.addEventListener eventType, handler, false
      else elem.attachEvent "on" + eventType, handler  if elem.attachEvent
      return


    ###*
    @private
    ###
    generatePosition_: (dataMatrix, unitWidth, unitHeight) ->
      printArray = (arr) ->
        str = ""
        cols = arr[0].length
        rows = arr.length
        k = 0
        while k < rows
          j = 0
          while j < cols
            str += arr[k][j]
            j++
          str += "\n"
          k++
        console.log str
        return
      top = 0
      left = 0
      x = 0
      y = 0
      cols = dataMatrix[x].length
      rows = dataMatrix.length
      foundSpot = false
      @largestElement = unitWidth  if unitWidth > @largestElement
      while y < rows
        x = 0
        while x < cols

          # Find an empty space.
          if dataMatrix[y][x] is 0

            # Check that surrounding elements equal to size are also free.
            allGood = true

            # Lets check bounds first.
            allGood = false  if (x + unitWidth - 1) >= cols
            allGood = false  if (y + unitHeight - 1) >= rows

            # If all good so far, then check each space.
            if allGood
              j = 0
              while j < unitWidth
                k = 0
                while k < unitHeight
                  if dataMatrix[y + k][x + j] isnt 0
                    allGood = false
                    break
                  k++
                break  unless allGood
                j++
            if allGood
              foundSpot = true
              left = (x * (@unitSize + @margin))
              top = (y * (@unitSize + @margin))
              @rowsTot = y + unitHeight  if (y + unitHeight) > @rowsTot

              # Now go and claim those spaces as taken.
              j = 0
              while j < unitWidth
                k = 0
                while k < unitHeight
                  dataMatrix[y + k][x + j] = 1
                  k++
                j++

              # Debug: Show dataMatrix steps.
              # printArray(dataMatrix);
              break
          x++
        break  if foundSpot
        y++
      if foundSpot
        top: top
        left: left
      else

        # If we could not fit in to the current row count, then lets expand our
        # rows and try again.
        @growMatrix_ dataMatrix, Math.ceil(dataMatrix.length / 2), 0
        @generatePosition_ dataMatrix, unitWidth, unitHeight


    ###*
    @private
    ###
    render_: ->
      data = @data
      dataMatrix = @matrix_(@rowsTot, @columns, 0)
      unitSize = @unitSize
      unless @initiated
        itterativeRender = ->
          if @renderDelay isnt `undefined`
            @elemCache[@itteration].setAttribute "class", "contentPlacerElement transition"
          else
            @elemCache[@itteration].setAttribute "class", "contentPlacerElement"
          @itteration++
          setTimeout itterativeRender.bind(this), @renderDelay  if @itteration < @elemCache.length
          return
        frag = document.createDocumentFragment()
        n = 0
        while n < data.length
          pos = @generatePosition_(dataMatrix, data[n].width, data[n].height)
          div = document.createElement("div")
          div.className = "contentPlacerElement"
          div.className += " hidden transition"  if @renderDelay isnt `undefined`
          div.style.width = ((data[n].width * unitSize) + ((data[n].width - 1) * @margin)) + "px"
          div.style.height = ((data[n].height * unitSize) + ((data[n].height - 1) * @margin)) + "px"
          div.style.top = pos.top + "px"
          div.style.left = pos.left + "px"
          div.innerHTML = data[n].content
          frag.appendChild div
          n++
        rHeight = ((@rowsTot * unitSize) + ((@rowsTot - 1) * @margin))
        container = document.createElement("div")
        container.className = "contentPlacerContainer"
        container.style.height = rHeight + "px"
        container.appendChild frag
        @target.appendChild container
        @target.style.height = rHeight + "px"
        @target.style.minWidth = ((unitSize + @margin) * @largestElement) + "px"
        @elemCache = document.getElementsByClassName("contentPlacerElement")

        # If render delay specified, fade in images each after that delay.
        if @renderDelay isnt `undefined`
          @itteration = 0
          setTimeout itterativeRender.bind(this), 5
        @initiated = true
      else
        n = 0
        while n < data.length
          pos = @generatePosition_(dataMatrix, data[n].width, data[n].height)
          @elemCache[n].style.top = pos.top + "px"
          @elemCache[n].style.left = pos.left + "px"
          @elemCache[n].style.width = ((data[n].width * unitSize) + ((data[n].width - 1) * @margin)) + "px"
          @elemCache[n].style.height = ((data[n].height * unitSize) + ((data[n].height - 1) * @margin)) + "px"
          n++

        # Update height of containers.
        rHeight = ((@rowsTot * unitSize) + ((@rowsTot - 1) * @margin))
        @target.style.height = rHeight + "px"
        @target.children.item(0).style.height = rHeight + "px"
      return


    # Public functions to programatically change things after initial instance has
    # been created.

    ###*
    Set a new margin size.
    ###
    setMargin: (marginSizePx) ->
      @margin = marginSizePx
      @columns = Math.max(Math.floor(@target.offsetWidth / (@unitSize + @margin)), @largestElement)
      @render_()
      return


    ###*
    Set a new default unit size.
    ###
    setUnitSize: (size) ->
      @unitSize = size
      @columns = Math.max(Math.floor(@target.offsetWidth / (@unitSize + @margin)), @largestElement)
      @render_()
      return


    ###*
    Set new data to use, overwrites existing.
    @param {Array.<Object>} dataArray An array containing data we wish to use.
    ###
    setData: (dataArr) ->
      @data = dataArr
      @findLargestNode_()
      @calculateColumns_()
      @target.innerHTML = ""
      @initiated = false
      @render_()
      return


    ###*
    Add new data to use, appends to existing.
    @param {Array.<Object>} dataArray An array containing data we wish to add.
    ###
    addData: (dataArr) ->
      @data = @data.concat(dataArr)
      @findLargestNode_()
      @calculateColumns_()
      @target.innerHTML = ""
      @initiated = false
      @render_()
      return


    ###*
    Set a new transition delay.
    ###
    setDelay: (delayMs) ->
      @renderDelay = delayMs
      return

  return ContentPlacer
