class Base.Linear extends Base

  # Sets data-svgchart-type to svg and creates ruler
  constructor: ->
    super
    @ruler = new Ruler()
    @width  = 100
    @height = 100
    @units  = "%"

  # Draws the chart
  draw: ->
    super
    do @_setItemAnchorSize
    do @_drawRuler
    do @drawItems

  # Draws all chart items
  drawItems: ->
    @_drawItem label, index for label, index in @data.labels
    @_drawItemSeparator index

  # Draws a chart dataset item
  # @param label The label
  # @param index The index position
  _drawItem: (label, index) ->
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
    if not @options.withoutRuler then @_drawBarLabel label, attributes, index
    @_drawItemSeparator index

  # Draws a item bar
  # @param label The label
  # @param dataset The dataset
  # @param attributes The position and size attributes of the elemnt
  # @param index The dataset index
  # @param subindex The dataset values index
  _drawBar: (label, dataset, attributes, index, subindex) ->
    ui_bar = new UI.Element "rect",
      "x"       : "#{attributes.x}#{@units}"
      "y"       : "#{attributes.y}#{@units}"
      "width"   : "#{attributes.width}#{@units}"
      "height"  : "#{attributes.height}#{@units}"
      "class"   : "item index_#{subindex}"
    @attachItemEvents ui_bar, dataset, index
    @_appendUIElement ui_bar
    if @_appendAnimation then @_appendAnimation(ui_bar)

  # Draws the item label
  # @param label The label
  # @param attributes The ui element attributes
  # @param index The dataset index
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
  _drawRuler: ->
    if @options.drawRuler is false then @options.withoutRuler = true
    @ruler.setLimits @min, @max
    # if not @options.withoutRuler then console.log "no tiene que pintarse nada"
    margins =
      top: @options.marginTop
      right: @options.marginRight
      bottom: @options.marginBottom
      left: @options.marginLeft
    @ruler.setLinearCoords @drawable_height, @drawable_width, margins
    if not @options.withoutRuler
      # lines
      @_drawRuleLine @ruler.coords.zero, true
      @_drawRuleLine coords for coords in @ruler.coords.lines
      # labels
      zero_coords = x:@ruler.coords.zero.x1, y: @height - @options.marginBottom, label: "0"
      @_drawRulerLabel(labelData) for labelData, i in @ruler.coords.labels

  # Draws ruler line
  # @param coords The line coordinates of the line
  # @param isZero True if the line indicates 0 position
  _drawRuleLine: (coords, isZero = false) ->
    line = new UI.Element "line",
      "x1"    : "#{coords.x1}#{@units}"
      "x2"    : "#{coords.x2}#{@units}"
      "y1"    : "#{coords.y1}#{@units}"
      "y2"    : "#{coords.y2}#{@units}"
      "class" : "ruler#{if isZero then " zero" else ""}"
    @_appendUIElement line

  # Draws ruler label
  # @param attributes The ui element attributes
  # @param isZero True if the line indicates 0 position
  _drawRulerLabel: (attributes, isZero=false) ->
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

  _setItemAnchorSize: -> @
