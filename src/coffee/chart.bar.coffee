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
    @item_anchor_size = @drawable_area_width / (@data.length - diff)

  # Returns real width of a bar
  calcItemW: (value) ->
    if @is_data_table
      w = (@item_anchor_size / @data[0].length - BARS_PADDING / @data[0].length) / @drawable_area_width
      # w = (@item_anchor_size / @data[0].length) / @drawable_area_width
    else
      w = (@item_anchor_size - BARS_PADDING) / @drawable_area_width
    if w is 0 then 0.01 else w

  # Returns height factor of a bar
  calcItemH: (value) ->
    h = Math.abs(@ruler.zero - Maths.rangeToPercent(value, @ruler.min, @ruler.max))
    if h is 0 then 0.01 else h

  # Returns real X position of a bar based on index
  calcItemX: (index, value, width, index2) ->
    if @is_data_table
      delta = (@item_anchor_size - BARS_PADDING) / @data[0].length
      ((@item_anchor_size * index + delta * index2) + BARS_PADDING * 0.5) / @drawable_area_width
    else
      ((@item_anchor_size * index) + (BARS_PADDING * 0.5)) / @drawable_area_width

  # Returns position y factor of a bar
  calcItemY: (index, value, height, index2) ->
    v = if value < 0 then @ruler.zero else @ruler.zero + height
    return 1 - v

  # Attaches events to bar UI element
  attachItemEvents: (bar, barData) ->
    # tt = new Tooltip(@svg, bar, barData.label, barData.value)

  # attachItemEvents: (bar, barData) ->
  #   x = parseFloat(bar.attr("x").replace("%", ""))
  #   y = parseFloat(bar.attr("y").replace("%", ""))
  #   textX = (x + @item_anchor_size / 2 - BARS_PADDING / 2) + "%"
  #   textY = (y + 3) + "%"
  #   textElement = new UI.Element "text", {
  #     x: textX
  #     y: textY
  #     "text-anchor"   : "middle"
  #     "pointer-events": "none"
  #   }
  #   textElement.element.textContent = barData.value

  #   bar.bind "click", (e) ->
  #     alert "label: #{barData.label}, value: #{barData.value}"

  #   bar.bind "mouseover", (e) =>
  #     bar.addClass "over"
  #     @appendUIElement textElement

  #   bar.bind "mouseout", (e) ->
  #     bar.removeClass "over"
  #     textElement.remove()
