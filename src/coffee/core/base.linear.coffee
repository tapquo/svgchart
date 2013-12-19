class Base.Linear extends Base

  # Define bars separation
  BARS_PADDING = 1

  # Sets data-svgchart-type to svg and creates ruler
  constructor: ->
    super
    @ruler = new Ruler()
    @margins = top: 0, right: 0, bottom: 0, left: 0
    @width = 100
    @height = 100

  # Draws all the chart
  draw: ->
    super
    do @_setItemAnchorSize
    do @drawDrawableContainer
    do @drawRulerDivisors
    for itemData, index in @data.slice(if @is_data_table then "1" else "0")
      @drawItem(itemData, index)

  # Calcs drawable area width and height based on margins
  calcDrawableArea: ->
    @drawable_width  = @width - @margins.left - @margins.right
    @drawable_height = @height - @margins.top - @margins.bottom

  # Draws a square for the drawable area with ruler styles
  drawDrawableContainer: ->
    uiel = new UI.Element.Bar("rect", {
      class   : "ruler"
      x       : "#{@margins.left}%"
      y       : "#{@margins.top}%"
      width   : "#{@drawable_width}%"
      height  : "#{@drawable_height}%"
    })
    @_appendUIElement uiel

  # Draws a bar
  drawItem: (data, index) ->
    if @is_data_table
      @_drawItem(@data[0][index2], value, index, index2) for value, index2 in data
    else @_drawItem(data.label, data.value, index)

  _drawItem: (label, value, index, index2=null) ->
    factor_h = @calcItemH value
    factor_y = @calcItemY index, value, factor_h, index2
    factor_w = @calcItemW value
    factor_x = @calcItemX index, value, factor_w, index2

    attributes =
      "x"       : @drawable_width * factor_x + @margins.left
      "y"       : @drawable_height * factor_y + @margins.top
      "width"   : @drawable_width * factor_w
      "height"  : @drawable_height * factor_h

    # Draw bar
    ui_bar = new UI.Element.Bar "rect",
      "x"       : "#{attributes.x}%"
      "y"       : "#{attributes.y}%"
      "width"   : "#{attributes.width}%"
      "height"  : "#{attributes.height}%"
      "class"   : "bar"
    @attachItemEvents ui_bar, {label: label, value: value}
    @_appendUIElement ui_bar

    # Draw label
    if @ruler.axis is "y"
      ui_label = new UI.Element "text",
        "x"               : "#{attributes.x + @item_anchor_size * 0.5 - BARS_PADDING * 0.5}%"
        "y"               : "#{@height - @margins.bottom * 0.5}%"
        "text-anchor"     : "middle"
        "pointer-events"  : "none"
    else
      ui_label = new UI.Element "text",
        "x"               : "#{@margins.left}%"
        "y"               : "#{@item_anchor_size * index + @item_anchor_size * 0.5 + @margins.top}%"
        "dx"              : "-1%"
        "dy"              : "1%"
        "text-anchor"     : "end"
        "pointer-events"  : "none"

    ui_label.element.textContent = label
    @_appendUIElement ui_label


  # Ruler draw functions
  drawRulerDivisors: ->
    @ruler.setLimits @min, @max
    @ruler.setLinearCoords @drawable_height, @drawable_width, @margins
    # lines
    @drawRuleLine @ruler.coords.zero, true
    @drawRuleLine coords for coords in @ruler.coords.lines
    # labels
    zero_coords = x:@ruler.coords.zero.x1, y: @height - @margins.bottom, label: "0"
    @drawRulerLabel zero_coords, true
    @drawRulerLabel(labelData) for labelData, i in @ruler.coords.labels

  drawRuleLine: (coords, isZero=false) ->
    zeroClass = if isZero then " zero" else ""
    line = new UI.Element "line",
      "x1"    : "#{coords.x1}%"
      "x2"    : "#{coords.x2}%"
      "y1"    : "#{coords.y1}%"
      "y2"    : "#{coords.y2}%"
      "class" : "ruler#{zeroClass}"
    @_appendUIElement line

  drawRulerLabel: (attributes, isZero=false) ->
    labelDef =
      "x"           : "#{attributes.x}%"
      "y"           : "#{attributes.y}%"
      "class"       : if isZero then "zero" else ""

    if @ruler.axis is "y"
      labelDef.dx = "-1%"
      labelDef.dy = "1%"
      labelDef["text-anchor"] = "end"
    else
      labelDef.dy = "2%"
      labelDef["text-anchor"] = "middle"

    uiel = new UI.Element "text", labelDef
    uiel.element.textContent = parseFloat(attributes.label).toFixed(0)
    @_appendUIElement uiel

  attachItemEvents: (bar, barData) ->
    bar.bind "mouseover", ->
      bar.addClass "over"
      Tooltip.html _tooltipHTML(barData)
      Tooltip.show()

    bar.bind "mouseleave", (e) ->
      bar.removeClass "over"
      Tooltip.hide()

  _tooltipHTML = (data) ->
    """
    #{data.label}
    <h1>#{data.value}</h1>
    """
