class Chart.Bar extends Base

  RULER_LINES     = 7
  RULER_FONT_SIZE = 15

  DRAWABLE_MARGIN_BOTTOM  = 10
  DRAWABLE_MARGIN_TOP     = 2
  DRAWABLE_MARGIN_LEFT    = 15
  DRAWABLE_MARGIN_RIGHT   = 2

  BARS_PADDING = 1


  _createBar: (attributes, barData) ->
    attributes.class = "bar"
    uiel = new UI.Element.Bar "rect", attributes
    uiel.bind "click", (e) ->
      alert "#{barData.label} -- #{barData.value}"
    @appendUIElement uiel

  constructor: ->
    super
    @svg.setAttribute "data-svgchart-type", "bar"

  calcRuler: ->
    @ruler_lines = @ruler_lines or RULER_LINES
    if @max_value >= 0 and @min_value >= 0
      @ruler_zero_pos = 0
      @ruler_max = @max_value
      @ruler_min = 0
    else if @max_value <= 0 and @min_value <= 0
      @ruler_zero_pos = 100
      @ruler_max = 0
      @ruler_min = @min_value
    else
      @ruler_max = @max_value
      @ruler_min = @min_value
      @ruler_zero_pos = Maths.rangeToPercent(0, @ruler_min, @ruler_max)

    delta = (@ruler_max - @ruler_min) / (@ruler_lines - 1)
    @ruler_divisors = (parseFloat(@ruler_min + delta * i).toFixed(1) for i in [0..@ruler_lines - 1])


  drawRuler: ->
    delta = (100 - DRAWABLE_MARGIN_BOTTOM - DRAWABLE_MARGIN_TOP) / (@ruler_lines - 1)
    zeroY = @ruler_zero_pos
    # console.log zeroY, @calcTopDrawPercent(zeroY)
    for divisorVal, i in @ruler_divisors.reverse()
      y = (delta * i) + DRAWABLE_MARGIN_TOP
      #@TODO :: Fix this deltaText (wrong calc)
      deltaText = (RULER_FONT_SIZE * 100 / @height / 2) - 0.25
      textUI = new UI.Element "text", {
        class         : "ruler_text"
        "x"           : "#{DRAWABLE_MARGIN_LEFT - 0.5}%"
        "y"           : "#{y + deltaText}%"
        "text-anchor" : "end"
        "font-size"   : RULER_FONT_SIZE
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
    # calc x position and width
    x = (@barWidth * index) + (BARS_PADDING / 2) + DRAWABLE_MARGIN_LEFT
    width = @barWidth - BARS_PADDING
    width = if width < 1 then 1 else width
    # calc y position and height
    value = Maths.rangeToPercent(value, @min_value, @max_value) - @ruler_zero_pos
    height = Math.abs(@drawable_area_height * value / 100)
    y = 100 - DRAWABLE_MARGIN_BOTTOM - (@drawable_area_height * @ruler_zero_pos / 100)
    if value > 0 then y -= height
    height = if height is 0 then 0.2 else height
    # draw bar
    attributes = { x: "#{x}%", y: "#{y}%", width: "#{width}%", height: "#{height}%" }
    @_createBar attributes, itemData
    # draw label
    textUI = new UI.Element "text", {
      class         : "ruler_text"
      x             : "#{x + @barWidth / 2}%"
      y             : "#{100 - DRAWABLE_MARGIN_BOTTOM / 2}%"
      "text-anchor" : "middle"
      "font-size"   : RULER_FONT_SIZE
    }
    textUI.element.textContent = label
    @appendUIElement(textUI)


  calcDrawableArea: ->
    @drawable_area_width  = 100 - DRAWABLE_MARGIN_LEFT - DRAWABLE_MARGIN_RIGHT
    @drawable_area_height = 100 - DRAWABLE_MARGIN_TOP - DRAWABLE_MARGIN_BOTTOM

  drawDrawableContainer: ->
    uiel = new UI.Element.Bar "rect", {
      class   : "ruler"
      x       : "#{DRAWABLE_MARGIN_LEFT}%"
      y       : "#{DRAWABLE_MARGIN_TOP}%"
      width   : "#{@drawable_area_width}%"
      height  : "#{@drawable_area_height}%"
    }
    @appendUIElement uiel

  draw: ->
    vals = (item.value for item in @data)
    do @calcDrawableArea
    @max_value = Maths.max(vals)
    @min_value = Maths.min(vals)
    @barWidth = @drawable_area_width / @data.length
    do @calcRuler
    do @drawDrawableContainer
    @drawItem(itemData, index) for itemData, index in @data
    do @drawRuler

