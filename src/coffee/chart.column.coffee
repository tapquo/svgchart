class Chart.Column extends Base.Linear

  DEFAULT_OPTIONS =
    marginTop         : 2
    marginRight       : 2
    marginBottom      : 4
    marginLeft        : 10
    barsPadding       : 1
    animationDuration : ".6s"

  constructor: (@container, options = {}) ->
    super
    @svg.setAttribute "data-svgchart-type", "bar"
    options = Utils.mergeOptions DEFAULT_OPTIONS, options
    @options = Utils.mergeOptions @options, options
    @ruler.axis = "y"

  # Sets width of the bar
  _setItemAnchorSize: ->
    @item_anchor_size = @drawable_width / @data.labels.length

  # Returns real width of a bar
  calcItemW: (value) ->
    n_datasets = @data.dataset.length
    w = (@item_anchor_size - @options.barsPadding) / n_datasets / @drawable_width
    if w is 0 then 0.01 else w

  # Returns height factor of a bar
  calcItemH: (value) ->
    h = @ruler.zero - Maths.rangeToPercent(value, @ruler.min, @ruler.max)
    if h is 0 then 0.01 else Math.abs(h)

  # Returns X position of a bar based on index, margins and drawable area
  calcItemX: (index, value, width, index2) ->
    deltaX = (@item_anchor_size - @options.barsPadding) / @data.dataset.length * index2
    ((@item_anchor_size * index + deltaX) + (@options.barsPadding * 0.5)) / @drawable_width

  # Returns position y factor of a bar
  calcItemY: (index, value, height, index2) ->
    v = if value < 0 then @ruler.zero else @ruler.zero + height
    return 1 - v

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

  _appendAnimation: (el) ->
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