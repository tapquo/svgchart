class Base.Angular extends Base

  NUM_COLORS = 5

  # Sets data-svgchart-type to svg and creates ruler
  constructor: ->
    super
    @width = 100
    @height = 100

  # Draws all the chart
  draw: ->
    do @_calcDrawableArea
    do @_setMaxMin
    do @_setTotal
    do @drawItems

  # Calcs drawable area width and height based on margins,
  # pie center coordinates, and pie radius
  _calcDrawableArea: ->
    @real_margins =
      top     : @real_width * @margins.top / 100
      right   : @real_width * @margins.right / 100
      bottom  : @real_width * @margins.bottom / 100
      left    : @real_width * @margins.left / 100

    @drawable_width  = @real_width - @real_margins.left - @real_margins.right
    @drawable_height = @real_height - @real_margins.top - @real_margins.bottom
    @centerX = (@drawable_width / 2) + @real_margins.left
    @centerY = (@drawable_height / 2) + @real_margins.top
    @radius = Maths.min([@drawable_width, @drawable_height]) / 2

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

  # Creates arc definition for the path element
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
      color_index =  index % NUM_COLORS
      @_drawItemArc startAngle, endAngle, color_index, data
      @_drawItemLabel (startAngle + angle * 0.5), "#{label} (#{value})", factor, color_index
      startAngle += angle

  # Draws element arc
  _drawItemArc: (startAngle, endAngle, index, data) ->
    uiel = new UI.Element "path",
      "class"         : "color_#{index}"
      "d"             : @describeArc(startAngle, endAngle)
    @attachItemEvents uiel, data
    @_appendUIElement uiel

  # Draws element arc label
  _drawItemLabel: (angle, value, factor, color) ->
    labelPos = @polarToCartesian(angle, @radius - 10)
    dy = 10 * Math.cos(angle)
    labelParams =
      "x"           : labelPos.x - 2
      "y"           : labelPos.y
      "dy"          : 10 * Math.cos(angle)
      "text-anchor" : if angle > Math.PI then "start" else "end"
    uiel = new UI.Element "text", labelParams
    uiel.element.textContent = Math.round(factor * 100) + "%"
    @_appendUIElement uiel


  attachItemEvents: (bar, barData) ->
    bar.bind "mouseover", ->
      bar.addClass "over"
      Tooltip.html _tooltipHTML(barData)
      Tooltip.show()
    bar.bind "mouseleave", ->
      bar.removeClass "over"
      Tooltip.hide()

  _tooltipHTML = (data) ->
    """
    Label: #{data.label} <br/>
    Value: <strong>#{data.value}</strong>
    """