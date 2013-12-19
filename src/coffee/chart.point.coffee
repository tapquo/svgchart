class Chart.Point extends Base.Linear

  constructor: ->
    super
    @points = []
    @svg.setAttribute "data-svgchart-type", "point"
    @ruler.axis = "y"
    @setMargins 2, 2, 15, 15

  drawItem: (data, index) ->
    factorY = 1 - Maths.rangeToPercent(data.value, @ruler.min, @ruler.max)
    cy = @margins.top + @drawable_height * factorY
    cx = @margins.left + index * @item_anchor_size
    attributes =
      cx  : "#{cx}%"
      cy  : "#{cy}%"
      r   : 4
    el = new UI.Element("circle", attributes)
    @_appendUIElement el

    @points.push
      x: cx * @real_width / 100
      y: cy * @real_height / 100

    if index is @data.length - 1
      zero_y = ((1 - @ruler.zero) * @drawable_height + @margins.top) * @real_height / 100
      start_zero_x = @margins.left * @real_width / 100
      end_zero_x = (@margins.left + @drawable_width) * @real_width / 100
      pathDef = ["M #{start_zero_x} #{zero_y}"]
      pathDef.push "L #{p.x} #{p.y}" for p, i in @points
      pathDef.push "L #{end_zero_x} #{zero_y}"
      path = new UI.Element("path", {d: pathDef.join(" ")})
      @_appendUIElement path
      @points = []

  # Sets width of the bar
  _setItemAnchorSize: ->
    @item_anchor_size = @drawable_width / (@data.length - 1)

  # Attaches events to bar UI element
  attachItemEvents: (bar, barData) -> @