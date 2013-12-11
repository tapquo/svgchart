class Chart.Bar extends Base

  RULER_LINES  = 5

  DRAWABLE_MARGIN_BOTTOM  = 10
  DRAWABLE_MARGIN_LEFT    = 10
  DRAWABLE_MARGIN_TOP     = 1
  DRAWABLE_MARGIN_RIGHT   = 1

  BARS_PADDING = 1


  constructor: ->
    super
    @svg.setAttribute "data-svgchart-type", "bar"

  calcBarWidth: ->
    @barWidth = (100 - DRAWABLE_MARGIN_LEFT - DRAWABLE_MARGIN_RIGHT) / @data.length

  calcRuler: ->
    @ruler_lines = @ruler_lines or RULER_LINES
    if @max_value >= 0 and @min_value >= 0
      @ruler_max = @max_value
      @ruler_min = 0
    else if @max_value > 0 and @min_value < 0
      @ruler_max = @max_value
      @ruler_min = @min_value
    else if @max_value < 0 and @min_value < 0
      @ruler_max = 0
      @ruler_min = @min_value

    delta = (@ruler_max - @ruler_min) / (@ruler_lines - 1)
    @ruler_divisors = ((@ruler_min + delta * i) for i in [0..@ruler_lines - 1])
    console.log "Ruler [#{@ruler_max}:#{@ruler_min}]"
    console.log "RulerDivisors ", @ruler_divisors

  drawRuler: ->
    delta = (100  - DRAWABLE_MARGIN_BOTTOM - DRAWABLE_MARGIN_TOP) / (@ruler_lines - 1)
    for divisor, i in @ruler_divisors
      if i > 0 and i < @ruler_lines - 1
        y = (delta * i) + DRAWABLE_MARGIN_TOP
        uiel = new UI.Element "line", {
          x1: "#{DRAWABLE_MARGIN_LEFT}%"
          x2: "#{100 - DRAWABLE_MARGIN_RIGHT}%"
          y1: "#{y}%"
          y2: "#{y}%"
        }
        uiel.addClass "ruler"
        @appendUIElement(uiel)

  drawItem: (itemData, index) ->
    label = itemData.label
    value = itemData.value
    x = (@barWidth * index) + (BARS_PADDING / 2) + DRAWABLE_MARGIN_LEFT
    width = @barWidth - BARS_PADDING
    width = if width < 1 then 1 else width
    height = Maths.rangeToPercent(value, @ruler_min, @ruler_max)
    height -= (DRAWABLE_MARGIN_TOP + DRAWABLE_MARGIN_BOTTOM)
    y = (100 - DRAWABLE_MARGIN_BOTTOM - height)
    uiel = new UI.Element.Bar "rect", {
      width   : "#{width}%"
      height  : "#{height}%"
      x       : "#{x}%"
      y       : "#{y}%"
    }
    uiel.addClass "bar"
    @appendUIElement uiel

  drawDrawableContainer: ->
    width = 100 - DRAWABLE_MARGIN_LEFT - DRAWABLE_MARGIN_RIGHT
    height = 100 - DRAWABLE_MARGIN_TOP - DRAWABLE_MARGIN_BOTTOM
    x = DRAWABLE_MARGIN_LEFT
    y = DRAWABLE_MARGIN_TOP
    uiel = new UI.Element.Bar "rect",
      width   : "#{100 - DRAWABLE_MARGIN_LEFT - DRAWABLE_MARGIN_RIGHT}%"
      height  : "#{100 - DRAWABLE_MARGIN_TOP - DRAWABLE_MARGIN_BOTTOM}%"
      x       : "#{DRAWABLE_MARGIN_LEFT}%"
      y       : "#{DRAWABLE_MARGIN_TOP}%"

    uiel.addClass "ruler"
    @appendUIElement uiel

  draw: ->
    vals = (item.value for item in @data)
    @max_value = Maths.max(vals)
    @min_value = Maths.min(vals)
    do @calcBarWidth
    do @calcRuler
    do @drawDrawableContainer
    @drawItem(itemData, index) for itemData, index in @data
    do @drawRuler

