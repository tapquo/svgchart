class Chart.Column extends Base.Linear

  DEFAULT_OPTIONS =
    barsPadding       : 1
    showAnimation     : true
    animationDuration : "0.6s"
    marginTop         : 2
    marginRight       : 2
    marginBottom      : 4
    marginLeft        : 10
    withoutYRuler     : false
    withoutXRuler     : false

  constructor: (@container, options = {}) ->
    super
    widthColumn = options.widthColumn
    @svg.setAttribute "data-svgchart-type", "bar"
    options = Utils.mergeOptions DEFAULT_OPTIONS, options
    @options = Utils.mergeOptions @options, options
    @options.widthColumn = widthColumn
    @ruler.axis = "y"

  # Sets width of the bar
  _setItemAnchorSize: ->
    width = if @options.widthColumn? then @options.widthColumn else (@drawable_width / @data.labels.length)
    @item_anchor_size = width

  # Returns width factor of a bar bassed on item value
  # @param value The item value for calc the width
  calcItemW: (value) ->
    w = Math.abs((@item_anchor_size - @options.barsPadding) / @data.dataset.length / @drawable_width)
    if w is 0 then 0.01 else w

  # Returns height factor of a bar
  # @param value The item value for calc the height
  calcItemH: (value) ->
    h = Math.abs(@ruler.zero - Maths.rangeToPercent(value, @ruler.min, @ruler.max))
    if h is 0 then 0.01 else h

  # Returns X position of a bar based on index, margins and drawable area
  # @param index The dataset index
  # @param value The value to calc
  # @param width The width factor of the elemnt
  # @param index2 The dataset values index
  calcItemX: (index, value, width, index2) ->
    deltaX = (@item_anchor_size - @options.barsPadding) / @data.dataset.length * index2
    ((@item_anchor_size * index + deltaX) + (@options.barsPadding * 0.5)) / @drawable_width

  # Returns position Y factor of a bar
  # @param index The dataset index
  # @param value The value to calc
  # @param height The height factor of the elemnt
  # @param index2 The dataset values index
  calcItemY: (index, value, height, index2) ->
    v = if value < 0 then @ruler.zero else @ruler.zero + height
    return 1 - v

  # Draws a ruler line for separate the item ui elements
  # @param index The dataset index
  _drawItemSeparator: (index) ->
    x = @item_anchor_size * index + @options.marginLeft
    y1 = @options.marginTop
    y2 = @options.marginTop + @drawable_height
    separator = new UI.Element "line",
      x1: "#{x}#{@units}"
      x2: "#{x}#{@units}"
      y1: "#{y1}#{@units}"
      y2: "#{y2}#{@units}"
      class: "ruler item_separator"
    @_appendUIElement separator

  # Appends a animation element
  # @param el The ui element
  _appendAnimation: (el) ->
    if @options.showAnimation is true
      el.append new UI.Element "animate",
        "attributeType" : "XML"
        "attributeName" : "height"
        "begin"         : "0s"
        "dur"           : @options.animationDuration
        "fill"          : "freeze"
        "from"          : "0"
        "to"            : el.attr("height")
      if parseFloat(el.attr("y")) < @ruler.coords.zero.y1
        el.append new UI.Element "animate",
          "attributeType" : "XML"
          "attributeName" : "y"
          "begin"         : "0s"
          "dur"           : @options.animationDuration
          "fill"          : "freeze"
          "from"          : "#{@ruler.coords.zero.y1}%"
          "to"            : el.attr("y")
