class Chart.Bar extends Base.Linear

  BARS_PADDING = 1

  constructor: ->
    super
    @svg.setAttribute "data-svgchart-type", "bar"
    @ruler.axis = "y"
    @setMargins 10, 10, 10, 10

  # Sets width of the bar
  _setItemAnchorSize: ->
    @item_anchor_size = @drawable_width / @data.labels.length

  # Returns real width of a bar
  calcItemW: (value) ->
    n_datasets = @data.dataset.length
    w = (@item_anchor_size - BARS_PADDING) / n_datasets / @drawable_width
    if w is 0 then 0.01 else w

  # Returns height factor of a bar
  calcItemH: (value) ->
    h = @ruler.zero - Maths.rangeToPercent(value, @ruler.min, @ruler.max)
    if h is 0 then 0.01 else Math.abs(h)

  # Returns real X position of a bar based on index
  calcItemX: (index, value, width, index2) ->
    deltaX = (@item_anchor_size - BARS_PADDING) / @data.dataset.length * index2
    ((@item_anchor_size * index + deltaX) + (BARS_PADDING * 0.5)) / @drawable_width

  # Returns position y factor of a bar
  calcItemY: (index, value, height, index2) ->
    v = if value < 0 then @ruler.zero else @ruler.zero + height
    return 1 - v
