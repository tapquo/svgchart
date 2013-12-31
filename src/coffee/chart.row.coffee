class Chart.Row extends Base.Linear

  DEFAULT_OPTIONS =
    animationDuration : ".6s"
    marginTop         : 2
    marginRight       : 2
    marginBottom      : 4
    marginLeft        : 10

  constructor: (@container, options = {}) ->
    super
    @svg.setAttribute "data-svgchart-type", "row"
    options = Utils.mergeOptions DEFAULT_OPTIONS, options
    @options = Utils.mergeOptions options, @options
    @ruler.axis = "x"

  # Sets width of the bar
  _setItemAnchorSize: ->
    @item_anchor_size = @drawable_height / @data.labels.length

  # Returns real width of a bar
  calcItemW: (value) ->
    w = Math.abs(@ruler.zero - Maths.rangeToPercent(value, @ruler.min, @ruler.max))
    if w is 0 then 0.01 else w

  # Returns height factor of a bar
  calcItemH: (value) ->
    n_datasets = @data.dataset.length
    h = (@item_anchor_size - @options.barsPadding) / n_datasets / @drawable_height
    if h is 0 then 0.01 else h

  # Returns real X position of a bar based on index
  calcItemX: (index, value, width) ->
    if value < 0 then @ruler.zero - width else @ruler.zero

  # Returns position y factor of a bar
  calcItemY: (index, value, height, index2) ->
    deltaX = (@item_anchor_size - @options.barsPadding) / @data.dataset.length * index2
    ((@item_anchor_size * index + deltaX) + (@options.barsPadding * 0.5)) / @drawable_height

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
