class Base.Angular extends Base

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

  # Calcs drawable area width and height based on margins
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

  _setTotal: ->
    @total = 0
    @total += parseFloat(item.value) for item in @data

  polarToCartesian: (angle) ->
    angle -= Math.PI / 2
    x: @centerX + @radius * Math.cos(angle)
    y: @centerY + @radius * Math.sin(angle)

  describeArc: (startAngle, endAngle) ->
    start = @polarToCartesian(endAngle)
    end   = @polarToCartesian(startAngle)
    arcSweep = if endAngle - startAngle <= Math.PI then "0" else "1"
    return """
      M #{start.x} #{start.y}
      A #{@radius} #{@radius} 0 #{arcSweep} 0 #{end.x}, #{end.y}
      L #{@centerX} #{@centerY}
    """

  # Draws a bar
  drawItems: ->
    startDegrees = 0
    for data, index in @data
      value = data.value
      label = data.label
      factor = parseFloat(value / @total)
      degrees = 2 * Math.PI * factor
      uiel = new UI.Element "path",
        "stroke"        : "red"
        "stroke-width"  : 3
        "fill"          : "rgba(0,150,0,.2)"
        "d"             : @describeArc(startDegrees, degrees + startDegrees)
      @appendUIElement uiel
      console.debug @polarToCartesian(degrees + startDegrees)
      startDegrees += degrees


