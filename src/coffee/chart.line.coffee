class Chart.Line extends Base.Linear

  BARS_PADDING = 0

  constructor: ->
    super
    @svg.setAttribute "data-svgchart-type", "line"
    @ruler.axis = "x"
    @setMargins 2, 2, 3, 15

  # Sets width of the bar
  _setItemAnchorSize: ->
    diff = if @is_data_table then 1 else 0
    @item_anchor_size = @drawable_height / (@data.length - diff)

  # Returns real width of a bar
  calcItemW: (value) ->
    w = Math.abs(@ruler.zero - Maths.rangeToPercent(value, @ruler.min, @ruler.max))
    if w is 0 then 0.01 else w

  # Returns height factor of a bar
  calcItemH: (value) ->
    if @is_data_table
      anchor_size = @item_anchor_size / @data[0].length
      padding = BARS_PADDING / @data[0].length
    else
      anchor_size = @item_anchor_size
      padding = BARS_PADDING

    h = (anchor_size - padding) / @drawable_height
    if h is 0 then 0.01 else h

  # Returns real X position of a bar based on index
  calcItemX: (index, value, width) ->
    if value < 0 then @ruler.zero - width else @ruler.zero

  # Returns position y factor of a bar
  calcItemY: (index, value, height, index2) ->
    deltaY = if @is_data_table then (@item_anchor_size - BARS_PADDING) / @data[0].length * index2 else 0
    ((@item_anchor_size * index) + (deltaY) + (BARS_PADDING * 0.5)) / @drawable_height

