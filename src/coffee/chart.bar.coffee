class Chart.Bar extends Base

  # RULER_LINES     = 9
  # RULER_FONT_SIZE = 15

  DRAWABLE_MARGIN_BOTTOM  = 10
  DRAWABLE_MARGIN_TOP     = 10
  DRAWABLE_MARGIN_LEFT    = 10
  DRAWABLE_MARGIN_RIGHT   = 10

  BARS_PADDING = 1


  constructor: ->
    super
    @svg.setAttribute "data-svgchart-type", "bar"
    @ruler = new Ruler()
    @width = 100
    @height = 100

  draw: ->
    do @calcDrawableArea
    do @_setMaxMin
    @bar_width = @drawable_area_width / @data.length
    @ruler.setLimits @min_value, @max_value
    do @drawDrawableContainer
    @drawItem(itemData, index) for itemData, index in @data
    do @drawRulerLines

  calcDrawableArea: ->
    @drawable_area_width  = @width - DRAWABLE_MARGIN_LEFT - DRAWABLE_MARGIN_RIGHT
    @drawable_area_height = @height - DRAWABLE_MARGIN_TOP - DRAWABLE_MARGIN_BOTTOM

  drawDrawableContainer: ->
    uiel = new UI.Element.Bar("rect", {
      class   : "ruler"
      x       : "#{DRAWABLE_MARGIN_LEFT}%"
      y       : "#{DRAWABLE_MARGIN_TOP}%"
      width   : "#{@drawable_area_width}%"
      height  : "#{@drawable_area_height}%"
    })
    @appendUIElement uiel

  drawItem: (data, index) ->
    value = data.value
    factor_h = @calcItemH value
    factor_y = @calcItemY factor_h, value
    realX = @calcItemX(index)
    realW = @calcItemW()
    realY = @drawable_area_height * (1-factor_y) + DRAWABLE_MARGIN_TOP
    realH = @drawable_area_height * factor_h
    attributes =
      x       : "#{realX}%"
      y       : "#{realY}%"
      width   : "#{realW}%"
      height  : "#{realH}%"
    @appendBar attributes, data

  calcItemX: (index) ->
    (@bar_width * index) + (BARS_PADDING * 0.5) + DRAWABLE_MARGIN_LEFT

  calcItemW: ->
    w = @bar_width - BARS_PADDING
    if w < 1 then 1 else w

  calcItemH: (value) ->
    Math.abs(@ruler.zero - Maths.rangeToPercent(value, @ruler.min, @ruler.max))

  calcItemY: (h, value) ->
    if value < 0 then @ruler.zero else @ruler.zero + h


  appendBar: (attributes, barData) ->
    attributes.class = "bar"
    uiel = new UI.Element.Bar "rect", attributes
    @attachBarEvents(uiel, barData)
    @appendUIElement uiel

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
  drawRulerLines: ->
    delta = @drawable_area_height / (@ruler.divisors.length - 1)
    posY = DRAWABLE_MARGIN_TOP
    x1 = DRAWABLE_MARGIN_LEFT
    x2 = @width - DRAWABLE_MARGIN_RIGHT
    for value in @ruler.divisors.reverse()
      @drawRuleLine x1, x2, posY, posY
      posY += delta

  drawRuleLine: (x1, x2, y1, y2, isZero=false) ->
    line = new UI.Element "line",
      x1: "#{x1}%"
      x2: "#{x2}%"
      y1: "#{y1}%"
      y2: "#{y2}%"
      class: "ruler"
    @appendUIElement line


