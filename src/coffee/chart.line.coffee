class Chart.Line extends Base.Linear

  BARS_PADDING = 1

  constructor: ->
    super
    @svg.setAttribute "data-svgchart-type", "line"
    @ruler.axis = "x"
    @setMargins 2, 2, 15, 15

  # Sets width of the bar
  _setItemAnchorSize: ->
    @item_anchor_size = @drawable_area_height / @data.length

  # Returns real width of a bar
  calcItemW: (value) ->
    w = Math.abs(@ruler.zero - Maths.rangeToPercent(value, @ruler.min, @ruler.max))
    if w is 0 then 0.01 else w

  # Returns height factor of a bar
  calcItemH: (value) ->
    h = (@item_anchor_size - BARS_PADDING) / @drawable_area_height
    if h is 0 then 0.01 else h

  # Returns real X position of a bar based on index
  calcItemX: (index, value, width) ->
    if value < 0 then @ruler.zero - width else @ruler.zero

  # Returns position y factor of a bar
  calcItemY: (index, value, height) ->
    ((@item_anchor_size * index) + (BARS_PADDING * 0.5)) / @drawable_area_height

  # Attaches events to bar UI element
  attachItemEvents: (bar, barData) ->
    x = parseFloat(bar.attr("x").replace("%", ""))
    y = parseFloat(bar.attr("y").replace("%", ""))
    textX = (x + @item_anchor_size / 2 - BARS_PADDING / 2) + "%"
    textY = (y + 3) + "%"
    textElement = new UI.Element "text", {
      x: textX
      y: textY
      "text-anchor"   : "middle"
      "pointer-events": "none"
    }
    textElement.element.textContent = barData.value

    bar.bind "click", (e) ->
      alert "label: #{barData.label}, value: #{barData.value}"

    bar.bind "mouseover", (e) =>
      bar.addClass "over"
      @appendUIElement textElement

    bar.bind "mouseout", (e) ->
      bar.removeClass "over"
      textElement.remove()
