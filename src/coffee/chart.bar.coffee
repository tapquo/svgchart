class Chart.Bar extends Base

  # Define drawable area margins
  DRAWABLE_MARGIN_BOTTOM  = 15
  DRAWABLE_MARGIN_TOP     = 2
  DRAWABLE_MARGIN_LEFT    = 15
  DRAWABLE_MARGIN_RIGHT   = 2
  BARS_PADDING = 1

  # Sets data-svgchart-type to svg and creates ruler
  constructor: ->
    super
    @svg.setAttribute "data-svgchart-type", "bar"
    @ruler = new Ruler()
    @margins =
      top    : DRAWABLE_MARGIN_TOP
      right  : DRAWABLE_MARGIN_RIGHT
      bottom : DRAWABLE_MARGIN_BOTTOM
      left   : DRAWABLE_MARGIN_LEFT

    @width = 100
    @height = 100

  # Overrides default margins
  setMargins: (top, right, bottom, left) ->
    @margins =
      top     : top or @margins.top
      right   : right or @margins.right
      bottom  : bottom or @margins.bottom
      left    : left or @margins.left

  # Draws all the chart
  draw: ->
    do @calcDrawableArea
    do @_setMaxMin
    @bar_width = @drawable_area_width / @data.length
    @ruler.setLimits @min_value, @max_value
    do @drawDrawableContainer
    @drawItem(itemData, index) for itemData, index in @data
    do @drawRulerDivisors

  # Calcs drawable area width and height based on margins
  calcDrawableArea: ->
    @drawable_area_width  = @width - @margins.left - @margins.right
    @drawable_area_height = @height - @margins.top - @margins.bottom

  # Draws a square for the drawable area with ruler styles
  drawDrawableContainer: ->
    uiel = new UI.Element.Bar("rect", {
      class   : "ruler"
      x       : "#{@margins.left}%"
      y       : "#{@margins.top}%"
      width   : "#{@drawable_area_width}%"
      height  : "#{@drawable_area_height}%"
    })
    @appendUIElement uiel

  # Draws a bar
  drawItem: (data, index) ->
    value = data.value
    factor_h = @calcItemH value
    factor_y = @calcItemY factor_h, value
    realX = @calcItemX(index)
    realW = @calcItemW()
    realY = @drawable_area_height * (1-factor_y) + @margins.top
    realH = @drawable_area_height * factor_h
    attributes =
      x       : "#{realX}%"
      y       : "#{realY}%"
      width   : "#{realW}%"
      height  : "#{realH}%"
    @appendBar attributes, data

  # Returns real X position of a bar based on index
  calcItemX: (index) ->
    (@bar_width * index) + (BARS_PADDING * 0.5) + @margins.left

  # Returns real width of a bar
  calcItemW: ->
    w = @bar_width - BARS_PADDING
    if w < 1 then 1 else w

  # Returns height factor of a bar
  calcItemH: (value) ->
     h = Math.abs(@ruler.zero - Maths.rangeToPercent(value, @ruler.min, @ruler.max))
     if h is 0 then 0.01 else h

  # Returns position y factor of a bar
  calcItemY: (h, value) ->
    if value < 0 then @ruler.zero else @ruler.zero + h

  # Creates bar UI element and appends it to container
  appendBar: (attributes, barData) ->
    attributes.class = "bar"
    uiel = new UI.Element.Bar "rect", attributes
    @attachBarEvents(uiel, barData)
    @appendUIElement uiel

  # Attaches events to bar UI element
  attachBarEvents: (bar, barData) ->
    textX = (parseFloat(bar.attr("x").replace("%", "")) + @bar_width/2 - BARS_PADDING/2) + "%"
    textY = (parseFloat(bar.attr("y").replace("%", "")) + 3) + "%"
    textElement = new UI.Element "text", {
      x: textX
      y: textY
      "text-anchor"   : "middle"
      "pointer-events": "none"
    }
    textElement.element.textContent = barData.value

    bar.bind "click", (e) ->
      alert "label: #{barData.label}, value: #{barData.value}"

    bar.bind "mouseover", (e) =>
      bar.addClass "over"
      @appendUIElement textElement

    bar.bind "mouseout", (e) ->
      bar.removeClass "over"
      textElement.remove()


  # Ruler draw functions
  drawRulerDivisors: ->
    height = @drawable_area_height
    width = @drawable_area_width
    lines = @ruler.getLinearCoords(height, width, "y", @margins)
    @drawRuleLine(line) for line in lines

  drawRuleLine: (coords, isZero=false) ->
    line = new UI.Element "line",
      x1    : "#{coords.x1}%"
      x2    : "#{coords.x2}%"
      y1    : "#{coords.y1}%"
      y2    : "#{coords.y2}%"
      class : "ruler"
    console.log line
    @appendUIElement line





