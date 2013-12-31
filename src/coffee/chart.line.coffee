class ChartLine extends Base.Linear

  constructor: ->
    super
    @points = []
    @bars_padding = 0
    @fill_item = true
    @tension = 0.5
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
    @_drawSeparators points

  _drawItem: (dataset, value, index, subindex) ->
    zero_y = ((1 - @ruler.zero) * @drawable_height + @margins.top) * @real_height / 100
    factor_y = 1 - Maths.rangeToPercent(value, @ruler.min, @ruler.max)
    cy = @margins.top + @drawable_height * factor_y
    cx = @item_anchor_size * subindex + @margins.left
    attributes =
      r   : 6
      cx  : "#{cx}#{@units}"
      cy  : "#{cy}#{@units}"
      class: "item index_#{index}"
    el = new UI.Element("circle", attributes)
    @_appendUIElement el
    @attachItemEvents @data.labels[index], el, dataset, subindex
    x: cx * @real_width / 100
    y: cy * @real_height / 100

  _drawSeparators: (points) ->
    for point in points
      @_appendUIElement new UI.Element "line",
        x1: point.x
        x2: point.x
        y1: "#{@margins.top}#{@units}"
        y2: "#{@margins.top + @drawable_height}#{@units}"
        class: "ruler"

  _drawItemLabel: (index, point) ->
    label = @data.labels[index]
    labelEl = new UI.Element "text",
      "x"           : point.x
      "y"           : "#{@height - @margins.bottom / 2}#{@units}"
      "text-anchor" : "middle"
    labelEl.element.textContent = label
    @_appendUIElement labelEl

  _drawPath: (points, index) ->
    start_zero_x = @margins.left * @real_width / 100
    zero_y = ((1 - @ruler.zero) * @drawable_height + @margins.top) * @real_height / 100
    end_zero_x = (@margins.left + @drawable_width) * @real_width / 100
    pathDef = []
    if @fill_item
      pathDef.push "M #{start_zero_x} #{zero_y}"
      pathDef.push "L #{points[0].x},#{points[0].y}"
    else pathDef.push "M #{points[0].x},#{points[0].y}"

    num_points = points.length
    for i in [0..num_points - 2]
      xdiff = (points[i+1].x - points[i].x) * @tension
      pathDef.push "C"
      pathDef.push "#{points[i].x + xdiff},#{points[i].y}"
      pathDef.push "#{points[i+1].x - xdiff},#{points[i+1].y}"
      pathDef.push "#{points[i+1].x},#{points[i+1].y}"

    if @fill_item then pathDef.push "L #{end_zero_x},#{zero_y}"
    path = new UI.Element "path",
      "pointer-events"  : "none"
      "d"               : pathDef.join(" ")
    path.addClass "index_#{index}"
    @_appendUIElement path

  # Sets width of the bar
  _setItemAnchorSize: ->
    @item_anchor_size = @drawable_width / (@data.labels.length - 1)


class Chart.Line extends ChartLine
  constructor: ->
    super
    @fill_item = false
    @svg.setAttribute "data-svgchart-type", "line"
    @tension = 0

class Chart.Area extends ChartLine
  constructor: ->
    super
    @svg.setAttribute "data-svgchart-type", "area"

class Chart.Point extends ChartLine
  constructor: ->
    super
    @svg.setAttribute "data-svgchart-type", "point"
    @_drawPath = -> @
