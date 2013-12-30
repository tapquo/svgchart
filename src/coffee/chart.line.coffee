class Chart.Line extends Base.Linear

  constructor: ->
    super
    @points = []
    @bars_padding = 0
    @tension = 0.5
    @svg.setAttribute "data-svgchart-type", "line"
    @ruler.axis = "y"
    @setMargins 10, 10, 10, 10

  setTension: (tension) ->
    if tension >= 0 and tension <= 1
      @tension = tension
      return true
    console.error "Tension value must be >= 0 and <= 1"
    false

  drawItems: ->
    for dataset, index in @data.dataset
      points = []
      for value, subindex in dataset.values
        drawn_points = @_drawItem(dataset, value, index, subindex)
        points.push drawn_points
        if index is 0 then @_drawItemLabel subindex, drawn_points
      @_drawPath points, index

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

  _drawPath: (points, index) ->
    start_zero_x = @margins.left * @real_width / 100
    zero_y = ((1 - @ruler.zero) * @drawable_height + @margins.top) * @real_height / 100
    end_zero_x = (@margins.left + @drawable_width) * @real_width / 100
    pathDef = ["M #{start_zero_x} #{zero_y} L #{points[0].x},#{points[0].y}"]
    num_points = points.length
    for i in [0..num_points - 2]
      p0 = points[i]
      p1 = points[i+1]
      xdiff = (p1.x - p0.x) * @tension
      c0 = x: (p0.x + xdiff), y: p0.y
      c1 = x: (p1.x - xdiff), y: p1.y
      pathDef.push "C #{c0.x},#{c0.y} #{c1.x},#{c1.y} #{p1.x}, #{p1.y}"

    pathDef.push "L #{end_zero_x},#{zero_y}"
    path = new UI.Element("path", {d: pathDef.join(" ")})
    path.addClass "index_#{index}"
    @_appendUIElement path

  # Sets width of the bar
  _setItemAnchorSize: ->
    @item_anchor_size = @drawable_width / (@data.labels.length - 1)

