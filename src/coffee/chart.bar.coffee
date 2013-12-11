class Chart.Bar extends Base

  RULER_LINES     = 5
  RULER_FONT_SIZE = 10

  DRAWABLE_MARGIN_BOTTOM  = 10
  DRAWABLE_MARGIN_LEFT    = 8
  DRAWABLE_MARGIN_TOP     = 1
  DRAWABLE_MARGIN_RIGHT   = 1

  BARS_PADDING = 1


  constructor: ->
    super
    @svg.setAttribute "data-svgchart-type", "bar"

  calcBarWidth: ->
    @barWidth = @drawable_area_width / @data.length

  calcRuler: ->
    @ruler_lines = @ruler_lines or RULER_LINES
    if @max_value >= 0 and @min_value >= 0
      @ruler_zero_pos = 100
      @ruler_max = @max_value
      @ruler_min = 0
    else if @max_value > 0 and @min_value < 0
      @ruler_max = @max_value
      @ruler_min = @min_value
      @ruler_zero_pos = Maths.rangeToPercent(0, @ruler_min, @ruler_max)
      console.log "Zero pos :: #{@ruler_zero_pos}"
    else if @max_value < 0 and @min_value < 0
      @ruler_zero_pos = 0
      @ruler_max = 0
      @ruler_min = @min_value

    delta = (@ruler_max - @ruler_min) / (@ruler_lines - 1)
    @ruler_divisors = (parseInt(@ruler_min + delta * i) for i in [0..@ruler_lines - 1])
    console.log "Ruler [#{@ruler_max}:#{@ruler_min}]"
    console.log "RulerDivisors ", @ruler_divisors

  drawRuler: ->
    delta = (100 - DRAWABLE_MARGIN_BOTTOM - DRAWABLE_MARGIN_TOP) / (@ruler_lines - 1)
    for divisorVal, i in @ruler_divisors.reverse()
      y = (delta * i) + DRAWABLE_MARGIN_TOP
      # Paint label
      #@TODO :: Fix this deltaText (wrong calc)
      deltaText = (RULER_FONT_SIZE * 100 / @height / 2) - 0.25
      textUI = new UI.Element "text", {
        "x": "#{DRAWABLE_MARGIN_LEFT - 0.5}%"
        "y": "#{y + deltaText}%"
        "text-anchor": "end"
        "font-size": RULER_FONT_SIZE
      }
      textUI.element.textContent = divisorVal
      @appendUIElement(textUI)

      # Paint ruler line
      if i > 0 and i < @ruler_lines - 1
        uiel = new UI.Element "line", {
          class: "ruler"
          x1: "#{DRAWABLE_MARGIN_LEFT}%"
          x2: "#{100 - DRAWABLE_MARGIN_RIGHT}%"
          y1: "#{y}%"
          y2: "#{y}%"
        }
        @appendUIElement(uiel)

  drawItem: (itemData, index) ->
    label = itemData.label
    value = itemData.value
    x = (@barWidth * index) + (BARS_PADDING / 2) + DRAWABLE_MARGIN_LEFT
    width = @barWidth - BARS_PADDING
    width = if width < 1 then 1 else width
    height = @drawable_area_height * value / 100
    y = (100 - DRAWABLE_MARGIN_BOTTOM - height)
    uiel = new UI.Element.Bar "rect", {
      class   :"bar"
      x       :"#{x}%"
      y       :"#{y}%"
      width   :"#{width}%"
      height  :"#{height}%"
    }
    @appendUIElement uiel

  calcDrawableArea: ->
    @drawable_area_width  = 100 - DRAWABLE_MARGIN_LEFT - DRAWABLE_MARGIN_RIGHT
    @drawable_area_height = 100 - DRAWABLE_MARGIN_TOP - DRAWABLE_MARGIN_BOTTOM

  drawDrawableContainer: ->
    uiel = new UI.Element.Bar "rect", {
      class   :"ruler"
      x       :"#{DRAWABLE_MARGIN_LEFT}%"
      y       :"#{DRAWABLE_MARGIN_TOP}%"
      width   :"#{@drawable_area_width}%"
      height  :"#{@drawable_area_height}%"
    }
    @appendUIElement uiel

  draw: ->
    vals = (item.value for item in @data)
    @max_value = Maths.max(vals)
    @min_value = Maths.min(vals)
    do @calcDrawableArea
    do @calcBarWidth
    do @calcRuler

    @drawItem(itemData, index) for itemData, index in @data
    do @drawDrawableContainer
    do @drawRuler

