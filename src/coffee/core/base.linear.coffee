class Base.Linear extends Base

  # Define bars separation
  BARS_PADDING = 1

  # Sets data-svgchart-type to svg and creates ruler
  constructor: ->
    super
    @ruler = new Ruler()
    @margins = top: 0, right: 0, bottom: 0, left: 0
    @bars_padding = 0
    @width  = 100
    @height = 100
    @units  = "%"

  # Draws all the chart
  draw: ->
    super
    do @_setItemAnchorSize
    do @drawDrawableContainer
    do @drawRuler

    for label, index in @data.labels
      @drawItem label, index

  # Draws a square for the drawable area with ruler styles
  drawDrawableContainer: ->
    uiel = new UI.Element.Bar "rect", {
      class   : "ruler"
      x       : "#{@margins.left}#{@units}"
      y       : "#{@margins.top}#{@units}"
      width   : "#{@drawable_width}#{@units}"
      height  : "#{@drawable_height}#{@units}"
    }
    @_appendUIElement uiel

  drawItem: (label, index) ->
    for dataset, i in @data.dataset
      factor_h = @calcItemH(dataset.values[index])
      factor_y = @calcItemY(index, dataset.values[index], factor_h, i)
      factor_w = @calcItemW(dataset.values[index])
      factor_x = @calcItemX(index, dataset.values[index], factor_w, i)
      attributes =
        "x"       : @drawable_width * factor_x + @margins.left
        "y"       : @drawable_height * factor_y + @margins.top
        "width"   : @drawable_width * factor_w
        "height"  : @drawable_height * factor_h
      @_drawBar label, dataset, attributes, index
      i++

    @_drawBarLabel label, attributes, index

  _drawBar: (label, dataset, attributes, subindex) ->
    ui_bar = new UI.Element.Bar "rect",
      "x"       : "#{attributes.x}#{@units}"
      "y"       : "#{attributes.y}#{@units}"
      "width"   : "#{attributes.width}#{@units}"
      "height"  : "#{attributes.height}#{@units}"
      "class"   : "bar"
    @attachItemEvents label, ui_bar, dataset, subindex
    @_appendUIElement ui_bar

  _drawBarLabel: (label, attributes, index) ->
    if @ruler.axis is "y"
      ui_label = new UI.Element "text",
        "x"               : "#{@item_anchor_size * index + @item_anchor_size / 2 + @margins.left}#{@units}"
        "y"               : "#{@height - @margins.bottom * 0.5}#{@units}"
        "text-anchor"     : "middle"
        "pointer-events"  : "none"
    else
      ui_label = new UI.Element "text",
        "x"               : "#{@margins.left}#{@units}"
        "y"               : "#{@item_anchor_size * index + @item_anchor_size * 0.5 + @margins.top}#{@units}"
        "dx"              : "-1#{@units}"
        "dy"              : "1#{@units}"
        "text-anchor"     : "end"
        "pointer-events"  : "none"

    ui_label.element.textContent = label
    @_appendUIElement ui_label

  # Ruler draw functions
  drawRuler: ->
    @ruler.setLimits @min, @max
    @ruler.setLinearCoords @drawable_height, @drawable_width, @margins
    # lines
    @drawRuleLine @ruler.coords.zero, true
    @drawRuleLine coords for coords in @ruler.coords.lines
    # labels
    zero_coords = x:@ruler.coords.zero.x1, y: @height - @margins.bottom, label: "0"
    @drawRulerLabel zero_coords, true
    @drawRulerLabel(labelData) for labelData, i in @ruler.coords.labels

  drawRuleLine: (coords, isZero = false) ->
    zeroClass = if isZero then " zero" else ""
    line = new UI.Element "line",
      "x1"    : "#{coords.x1}#{@units}"
      "x2"    : "#{coords.x2}#{@units}"
      "y1"    : "#{coords.y1}#{@units}"
      "y2"    : "#{coords.y2}#{@units}"
      "class" : "ruler#{zeroClass}"
    @_appendUIElement line

  drawRulerLabel: (attributes, isZero=false) ->
    labelDef =
      "x"           : "#{attributes.x}#{@units}"
      "y"           : "#{attributes.y}#{@units}"
      "class"       : if isZero then "zero" else ""

    if @ruler.axis is "y"
      labelDef.dx = "-1#{@units}"
      labelDef.dy = "1#{@units}"
      labelDef["text-anchor"] = "end"
    else
      labelDef.dy = "2#{@units}"
      labelDef["text-anchor"] = "middle"

    uiel = new UI.Element "text", labelDef
    uiel.element.textContent = parseFloat(attributes.label).toFixed(2)
    @_appendUIElement uiel

  attachItemEvents: (label, bar, dataset, subindex) ->
    bar.bind "mouseover", ->
      bar.addClass "over"
      Tooltip.html _tooltipHTML(dataset, subindex)
      Tooltip.show()

    bar.bind "mouseleave", (e) ->
      bar.removeClass "over"
      Tooltip.hide()

  _tooltipHTML = (data, index) ->
    """
    #{data.name}
    <h1>#{data.values[index]}</h1>
    """


