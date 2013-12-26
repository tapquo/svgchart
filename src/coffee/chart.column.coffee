class Chart.Column extends Base.Linear

  constructor: ->
    super
    @bars_padding = 1
    @svg.setAttribute "data-svgchart-type", "bar"
    @ruler.axis = "y"
    @setMargins 10, 10, 10, 10

  # Sets width of the bar
  _setItemAnchorSize: ->
    @item_anchor_size = @drawable_width / @data.labels.length

  # Returns real width of a bar
  calcItemW: (value) ->
    n_datasets = @data.dataset.length
    w = (@item_anchor_size - @bars_padding) / n_datasets / @drawable_width
    if w is 0 then 0.01 else w

  # Returns height factor of a bar
  calcItemH: (value) ->
    h = @ruler.zero - Maths.rangeToPercent(value, @ruler.min, @ruler.max)
    if h is 0 then 0.01 else Math.abs(h)

  # Returns real X position of a bar based on index
  calcItemX: (index, value, width, index2) ->
    deltaX = (@item_anchor_size - @bars_padding) / @data.dataset.length * index2
    ((@item_anchor_size * index + deltaX) + (@bars_padding * 0.5)) / @drawable_width

  # Returns position y factor of a bar
  calcItemY: (index, value, height, index2) ->
    v = if value < 0 then @ruler.zero else @ruler.zero + height
    return 1 - v

  _appendAnimation: (el) ->
    el.append new UI.Element "animate",
      "attributeType" : "XML"
      "attributeName" : "height"
      "begin"         : "0s"
      "dur"           : "1s"
      "fill"          : "freeze"
      "from"          : "0"
      "to"            : el.attr("height")

    if parseFloat(el.attr("y").replace("%", "")) < @ruler.coords.zero.y1
      el.append new UI.Element "animate",
        "attributeType" : "XML"
        "attributeName" : "y"
        "begin"         : "0s"
        "dur"           : "1s"
        "fill"          : "freeze"
        "from"          : "#{@ruler.coords.zero.y1}%"
        "to"            : el.attr("y")