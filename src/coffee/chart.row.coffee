class Chart.Row extends Base.Linear

  DEFAULT_OPTIONS =
    barsPadding       : 1
    animationDuration : "0.6s"
    marginTop         : 2
    marginRight       : 2
    marginBottom      : 4
    marginLeft        : 10
    withoutYRuler     : false
    withoutXRuler     : false

  constructor: (@container, options = {}) ->
    super
    @svg.setAttribute "data-svgchart-type", "row"
    options = Utils.mergeOptions DEFAULT_OPTIONS, options
    @options = Utils.mergeOptions @options, options
    @ruler.axis = "x"

  # Sets width of the bar
  _setItemAnchorSize: ->
    @item_anchor_size = @drawable_height / @data.labels.length

  # Returns width factor of a bar bassed on item value
  # @param value The item value for calc the width
  calcItemW: (value) ->
    w = Math.abs(@ruler.zero - Maths.rangeToPercent(value, @ruler.min, @ruler.max))
    if w is 0 then 0.01 else w

  # Returns height factor of a bar
  # @param value The item value for calc the height
  calcItemH: (value) ->
    h = Math.abs((@item_anchor_size - @options.barsPadding) / @data.dataset.length / @drawable_height)
    if h is 0 then 0.01 else h

  # Returns X position of a bar based on index, margins and drawable area
  # @param index The dataset index
  # @param value The value to calc
  # @param width The width factor of the elemnt
  # @param index2 The dataset values index
  calcItemX: (index, value, width) ->
    if value < 0 then @ruler.zero - width else @ruler.zero

  # Returns position Y factor of a bar
  # @param index The dataset index
  # @param value The value to calc
  # @param height The height factor of the elemnt
  # @param index2 The dataset values index
  calcItemY: (index, value, height, index2) ->
    deltaX = (@item_anchor_size - @options.barsPadding) / @data.dataset.length * index2
    ((@item_anchor_size * index + deltaX) + (@options.barsPadding * 0.5)) / @drawable_height

  # Draws a ruler line for separate the item ui elements
  # @param index The dataset index
  _drawItemSeparator: (index) ->
    y = @item_anchor_size * index + @options.marginTop
    x1 = @options.marginLeft
    x2 = @options.marginLeft + @drawable_width
    separator = new UI.Element "line",
      x1: "#{x1}#{@units}"
      x2: "#{x2}#{@units}"
      y1: "#{y}#{@units}"
      y2: "#{y}#{@units}"
      class: "ruler item_separator"
    @_appendUIElement separator

  # Appends a animation element
  # @param el The ui element
  _appendAnimation: (el) ->
    el.append new UI.Element "animate",
      "attributeType" : "XML"
      "attributeName" : "width"
      "begin"         : "0s"
      "dur"           : @options.animationDuration
      "fill"          : "freeze"
      "from"          : "0"
      "to"            : el.attr("width")
    if parseFloat(el.attr("x")) < @ruler.coords.zero.x1
      el.append new UI.Element "animate",
        "attributeType" : "XML"
        "attributeName" : "x"
        "begin"         : "0s"
        "dur"           : @options.animationDuration
        "fill"          : "freeze"
        "from"          : "#{@ruler.coords.zero.x1}%"
        "to"            : el.attr("x")
