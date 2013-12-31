class Base.Linear extends Base

  # Sets data-svgchart-type to svg and creates ruler
  constructor: ->
    super
    @ruler = new Ruler()
    @width  = 100
    @height = 100
    @units  = "%"

  # Draws all the chart
  draw: ->
    super
    do @_setItemAnchorSize
    do @drawRuler
    do @drawItems

  drawItems: ->
    @drawItem label, index for label, index in @data.labels
    @_drawItemSeparator index

  drawItem: (label, index) ->
    for dataset, subindex in @data.dataset
      factor_h = @calcItemH(dataset.values[index])
      factor_y = @calcItemY(index, dataset.values[index], factor_h, subindex)
      factor_w = @calcItemW(dataset.values[index])
      factor_x = @calcItemX(index, dataset.values[index], factor_w, subindex)
      attributes =
        "x"       : @drawable_width * factor_x + @options.marginLeft
        "y"       : @drawable_height * factor_y + @options.marginTop
        "width"   : @drawable_width * factor_w
        "height"  : @drawable_height * factor_h
      @_drawBar label, dataset, attributes, index, subindex
    @_drawBarLabel label, attributes, index
    @_drawItemSeparator index

  _drawBar: (label, dataset, attributes, index, subindex) ->
    ui_bar = new UI.Element.Bar "rect",
      "x"       : "#{attributes.x}#{@units}"
      "y"       : "#{attributes.y}#{@units}"
      "width"   : "#{attributes.width}#{@units}"
      "height"  : "#{attributes.height}#{@units}"
      "class"   : "item index_#{subindex}"
    @attachItemEvents label, ui_bar, dataset, index
    @_appendUIElement ui_bar
    if @_appendAnimation then @_appendAnimation(ui_bar)

  _drawBarLabel: (label, attributes, index) ->
    labelAttributes = {"pointer-events"  : "none"}
    if @ruler.axis is "y"
      labelAttributes =
        "x"               : "#{@item_anchor_size * index + @item_anchor_size / 2 + @options.marginLeft}#{@units}"
        "y"               : "#{@height - @options.marginBottom * 0.5}#{@units}"
        "text-anchor"     : "middle"
    else
      labelAttributes =
        "x"               : "#{@options.marginLeft}#{@units}"
        "y"               : "#{@item_anchor_size * index + @item_anchor_size * 0.5 + @options.marginTop}#{@units}"
        "dx"              : "-1#{@units}"
        "dy"              : "1#{@units}"
        "text-anchor"     : "end"

    ui_label = new UI.Element "text", labelAttributes
    ui_label.element.textContent = label
    @_appendUIElement ui_label

  # Ruler draw functions
  drawRuler: ->
    @ruler.setLimits @min, @max
    margins =
      top: @options.marginTop
      right: @options.marginRight
      bottom: @options.marginBottom
      left: @options.marginLeft
    @ruler.setLinearCoords @drawable_height, @drawable_width, margins
    # lines
    @drawRuleLine @ruler.coords.zero, true
    @drawRuleLine coords for coords in @ruler.coords.lines
    # labels
    zero_coords = x:@ruler.coords.zero.x1, y: @height - @options.marginBottom, label: "0"
    # @drawRulerLabel zero_coords, true
    @drawRulerLabel(labelData) for labelData, i in @ruler.coords.labels

  drawRuleLine: (coords, isZero = false) ->
    line = new UI.Element "line",
      "x1"    : "#{coords.x1}#{@units}"
      "x2"    : "#{coords.x2}#{@units}"
      "y1"    : "#{coords.y1}#{@units}"
      "y2"    : "#{coords.y2}#{@units}"
      "class" : "ruler#{if isZero then " zero" else ""}"
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
    bar.bind "mouseover,touchstart", =>
      @tooltip.hide()
      @tooltip.html _tooltipHTML(dataset, subindex)
      @tooltip.show()
      clearTimeout @tooltip_timeout
      @tooltip_timeout = setTimeout @tooltip.hide, 2000
    bar.bind "mouseleave", (e) =>
      clearTimeout @tooltip_timeout
      @tooltip.hide()

  _setItemAnchorSize: -> @

  _tooltipHTML = (data, index) ->
    """
    #{data.name}
    <h1>#{data.values[index]}</h1>
    """
