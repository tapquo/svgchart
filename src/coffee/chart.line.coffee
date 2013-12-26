class Chart.Line extends Base.Linear

  constructor: ->
    super
    @points = []
    @bars_padding = 0
    @svg.setAttribute "data-svgchart-type", "line"
    @ruler.axis = "y"
    @setMargins 10, 10, 10, 10

  drawItems: ->
    for dataset, index in @data.dataset
      points = []
      for value, subindex in dataset.values
        drawn_points = @_drawItem(dataset, value, index, subindex)
        points.push drawn_points
        if index is 0 then @_drawItemLabel subindex, drawn_points
      @_drawPath points

  _drawItem: (dataset, value, index, subindex) ->
    zero_y = ((1 - @ruler.zero) * @drawable_height + @margins.top) * @real_height / 100
    factor_y = 1 - Maths.rangeToPercent(value, @ruler.min, @ruler.max)
    cy = @margins.top + @drawable_height * factor_y
    cx = @item_anchor_size * subindex + @margins.left
    attributes =
      r   : 3
      cx  : "#{cx}#{@units}"
      cy  : "#{cy}#{@units}"
      class: "item index_#{index}"
    el = new UI.Element("circle", attributes)
    @_appendUIElement el
    x: cx * @real_width / 100
    y: cy * @real_height / 100

  _drawItemLabel: (index, point) ->
    label = @data.labels[index]
    labelEl = new UI.Element "text",
      x: point.x
      y: "#{@height - @margins.bottom / 2}#{@units}"
      "text-anchor": "middle"
    labelEl.element.textContent = label
    @_appendUIElement labelEl

    console.log "pinto --- #{@data.labels[index]}, #{point.x}"

  _drawPath: (points) ->
    console.log "points :: ", points
    zero_y = ((1 - @ruler.zero) * @drawable_height + @margins.top) * @real_height / 100
    start_zero_x = @margins.left * @real_width / 100
    end_zero_x = (@margins.left + @drawable_width) * @real_width / 100
    pathDef = ["M #{start_zero_x} #{zero_y}"]
    pathDef.push "L #{point.x} #{point.y}" for point in points
    pathDef.push "L #{end_zero_x} #{zero_y}"
    path = new UI.Element("path", {d: pathDef.join(" ")})
    @_appendUIElement path

  #   factorY = 1 - Maths.rangeToPercent(data.value, @ruler.min, @ruler.max)
  #   cy = @margins.top + @drawable_height * factorY
  #   cx = @margins.left + index * @item_anchor_size
  #   attributes =
  #     cx  : "#{cx}%"
  #     cy  : "#{cy}%"
  #     r   : 4
  #   el = new UI.Element("circle", attributes)
  #   @_appendUIElement el

  #   @points.push
  #     x: cx * @real_width / 100
  #     y: cy * @real_height / 100

  #   if index is @data.length - 1
  #     zero_y = ((1 - @ruler.zero) * @drawable_height + @margins.top) * @real_height / 100
  #     start_zero_x = @margins.left * @real_width / 100
  #     end_zero_x = (@margins.left + @drawable_width) * @real_width / 100
  #     pathDef = ["M #{start_zero_x} #{zero_y}"]
  #     pathDef.push "L #{p.x} #{p.y}" for p, i in @points
  #     pathDef.push "L #{end_zero_x} #{zero_y}"
  #     path = new UI.Element("path", {d: pathDef.join(" ")})
  #     @_appendUIElement path
  #     @points = []

  # # Sets width of the bar
  _setItemAnchorSize: ->
    @item_anchor_size = @drawable_width / (@data.labels.length - 1)

  # # Attaches events to bar UI element
  # attachItemEvents: (bar, barData) -> @