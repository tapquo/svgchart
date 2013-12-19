class Chart.Bar extends Base.Linear

  BARS_PADDING = 1

  constructor: ->
    super
    @svg.setAttribute "data-svgchart-type", "bar"
    @ruler.axis = "y"
    @setMargins 2, 2, 15, 15

  # Sets width of the bar
  _setItemAnchorSize: ->
    diff = if @is_data_table then 1 else 0
    @item_anchor_size = @drawable_width / (@data.length - diff)

  # Returns real width of a bar
  calcItemW: (value) ->
    if @is_data_table
      anchor_size = @item_anchor_size / @data[0].length
      padding = BARS_PADDING / @data[0].length
    else
      anchor_size = @item_anchor_size
      padding = BARS_PADDING
    w = (anchor_size - padding) / @drawable_width
    if w is 0 then 0.01 else w

  # Returns height factor of a bar
  calcItemH: (value) ->
    h = @ruler.zero - Maths.rangeToPercent(value, @ruler.min, @ruler.max)
    if h is 0 then 0.01 else Math.abs(h)

  # Returns real X position of a bar based on index
  calcItemX: (index, value, width, index2) ->
    deltaX = if @is_data_table then (@item_anchor_size - BARS_PADDING) / @data[0].length * index2 else 0
    ((@item_anchor_size * index + deltaX) + (BARS_PADDING * 0.5)) / @drawable_width

  # Returns position y factor of a bar
  calcItemY: (index, value, height, index2) ->
    v = if value < 0 then @ruler.zero else @ruler.zero + height
    return 1 - v
