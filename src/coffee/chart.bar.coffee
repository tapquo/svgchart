class Chart.Bar extends Base

  BARS_PADDING = 1
  RULER_LINES  = 5

  constructor: ->
    super
    @drawableAreaLimits = []

  calcBarWidth: ->
    @barWidth = 100 / @data.length
    # @barWidth = @container.getAttribute("width") / @data.length

  setRuler: (@ruler_max, @ruler_min, @ruler_lines = RULER_LINES) -> @

  calcRuler: ->
    @ruler_lines = @ruler_lines or RULER_LINES
    if !@ruler_max or !@ruler_min
      if @max_value >= 0 and @min_value >= 0
        @ruler_max = @max_value
        @ruler_min = 0
      else if @max_value > 0 and @min_value < 0
        @ruler_max = @max_value
        @ruler_min = @min_value
      else if @max_value < 0 and @min_value < 0
        @ruler_max = 0
        @ruler_min = @min_value


    diff = (@ruler_max - @ruler_min) / (@ruler_lines - 1)
    @ruler_divisors = ((@ruler_min + diff * i) for i in [0..@ruler_lines - 1])

    console.log "Ruler [#{@ruler_max}:#{@ruler_min}]"
    console.log "RulerDivisors ", @ruler_divisors

  drawRuler: ->
    delta = 100 / @ruler_lines
    for divisor, i in @ruler_divisors
      y = delta * i
      uiel = new UI.Element "line", {
        x1: "0%",
        x2: "100%"
        y1: "#{y}%"
        y2: "#{y}%"
        style: "stroke:rgb(0,0,0);stroke-width:2;opacity:.1"
      }
      @appendUIElement(uiel)

  drawItem: (itemData, index) ->
    label = itemData.label
    value = itemData.value
    x = (@barWidth * index) + (BARS_PADDING / 2)
    width = @barWidth - BARS_PADDING
    width = if width < 1 then 1 else width
    height = Maths.rangeToPercent(value, @ruler_min, @ruler_max)
    y = (100 - height) + "%"

    console.log "===================================================="
    console.log "Value #{value} --> Height:#{parseInt(height)}, PosY:#{parseInt(y)}%"

    bar = new UI.Element.Bar "rect",
      width   : width + "%"
      height  : height + "%"
      x       : x + "%"
      y       : y
      fill    : "blue"

    @appendUIElement bar


  draw: ->
    vals = (item.value for item in @data)
    @max_value = Maths.max(vals)
    @min_value = Maths.min(vals)
    console.log "MaxMin [#{@max_value}:#{@min_value}]"
    do @calcBarWidth
    do @calcRuler
    @drawItem(itemData, index) for itemData, index in @data
    do @drawRuler

