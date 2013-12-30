class Chart.Row extends Base.Linear

  ANIMATION_DURATION = "0.6s"

  constructor: ->
    super
    @svg.setAttribute "data-svgchart-type", "row"
    @ruler.axis = "x"
    @setMargins 2, 2, 3, 15

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
    h = (@item_anchor_size - @bars_padding) / n_datasets / @drawable_height
    if h is 0 then 0.01 else h

  # Returns real X position of a bar based on index
  calcItemX: (index, value, width) ->
    if value < 0 then @ruler.zero - width else @ruler.zero

  # Returns position y factor of a bar
  calcItemY: (index, value, height, index2) ->
    deltaX = (@item_anchor_size - @bars_padding) / @data.dataset.length * index2
    ((@item_anchor_size * index + deltaX) + (@bars_padding * 0.5)) / @drawable_height

  _appendAnimation: (el) ->
    el.append new UI.Element "animate",
      "attributeType" : "XML"
      "attributeName" : "width"
      "begin"         : "0s"
      "dur"           : ANIMATION_DURATION
      "fill"          : "freeze"
      "from"          : "0"
      "to"            : el.attr("width")

    if parseFloat(el.attr("x")) < @ruler.coords.zero.x1
      el.append new UI.Element "animate",
        "attributeType" : "XML"
        "attributeName" : "x"
        "begin"         : "0s"
        "dur"           : ANIMATION_DURATION
        "fill"          : "freeze"
        "from"          : "#{@ruler.coords.zero.x1}%"
        "to"            : el.attr("x")