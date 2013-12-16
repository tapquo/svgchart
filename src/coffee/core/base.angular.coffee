class Base.Angular extends Base

  COLORS = [
    "rgba(221, 30, 47,.4)",
    "rgba(6, 162, 203,.4)",
    "rgba(235, 176, 53,.4)",
    "rgba(33, 133, 89,.4)",
    "rgba(208, 198, 177,.4)"
  ]


  # Define drawable area margins
  BARS_PADDING = 1

  # Sets data-svgchart-type to svg and creates ruler
  constructor: ->
    super
    @width = 100
    @height = 100

  # Draws all the chart
  draw: ->
    do @calcDrawableArea
    do @_setMaxMin
    do @_setTotal
    do @drawItems

  # Calcs drawable area width and height based on margins,
  # pie center coordinates, and pie radius
  calcDrawableArea: ->
    @real_margins =
      top     : @real_width * @margins.top / 100
      right   : @real_width * @margins.right / 100
      bottom  : @real_width * @margins.bottom / 100
      left    : @real_width * @margins.left / 100

    @drawable_area_width  = @real_width - @real_margins.left - @real_margins.right
    @drawable_area_height = @real_height - @real_margins.top - @real_margins.bottom
    @centerX = (@drawable_area_width / 2) + @real_margins.left
    @centerY = (@drawable_area_height / 2) + @real_margins.top
    @radius = Maths.min([@drawable_area_width, @drawable_area_height]) / 2

  # Sets total of all data values
  _setTotal: ->
    @total = 0
    @total += parseFloat(item.value) for item in @data

  # Returns cartesian coords of a given angle of the pie
  polarToCartesian: (angle, radius=null) ->
    radius = radius or @radius
    angle -= Math.PI / 2
    x: @centerX + radius * Math.cos(angle)
    y: @centerY + radius * Math.sin(angle)

  # Creates arc definition
  describeArc: (startAngle, endAngle) ->
    start = @polarToCartesian(endAngle)
    end   = @polarToCartesian(startAngle)
    arcSweep = if endAngle - startAngle <= Math.PI then "0" else "1"
    return """
      M #{start.x} #{start.y}
      A #{@radius} #{@radius} 0 #{arcSweep} 0 #{end.x}, #{end.y}
      L #{@centerX} #{@centerY}
    """

  # Draws a pie element
  drawItems: ->
    startAngle = 0
    for data, index in @data
      value = data.value
      label = data.label
      factor = parseFloat(value / @total)
      angle = 2 * Math.PI * factor
      endAngle = startAngle + angle
      color =  COLORS[index % (COLORS.length - 1)]
      @_drawItemArc startAngle, endAngle, color
      @_drawItemLabel (startAngle + angle * 0.5), value, factor, color
      startAngle += angle

  # Draws element arc
  _drawItemArc: (startAngle, endAngle, color) ->
    uiel = new UI.Element "path",
      "stroke"        : "#333"
      "stroke-width"  : 1
      "fill"          : color
      "d"             : @describeArc(startAngle, endAngle)
    @appendUIElement uiel

  # Draws element arc label
  _drawItemLabel: (angle, value, factor, color) ->
    labelPos = @polarToCartesian(angle, @radius + 15)
    labelParams =
      "x"           : labelPos.x
      "y"           : labelPos.y
      "text-anchor" : if angle > Math.PI then "end" else "start"
    uiel = new UI.Element "text", labelParams
    uiel.element.textContent = Math.round(factor * 100) + "%"
    @appendUIElement uiel

