class ChartLine extends Base.Linear

  DEFAULT_OPTIONS =
    marginTop     : 10
    marginRight   : 10
    marginBottom  : 10
    marginLeft    : 10
    bezierTension : 0.5

  constructor: (@container, options = {}) ->
    super
    options = Utils.mergeOptions DEFAULT_OPTIONS, options
    @options = Utils.mergeOptions @options, options

  drawItems: ->
    for dataset, index in @data.dataset
      points = []
      for value, subindex in dataset.values
        # drawn_points = @_getPointCoords(dataset, value, index, subindex)
        point = @_getPointCoords(dataset, value, index, subindex)
        points.push point
        if index is 0 then @_drawItemLabel subindex, point
      @_drawPath points, index
      @_drawDataset points, index, dataset
    @_drawSeparators points

  _getPointCoords: (dataset, value, index, subindex) ->
    zero_y = ((1 - @ruler.zero) * @drawable_height + @options.marginTop) * @real_height / 100
    factor_y = 1 - Maths.rangeToPercent(value, @ruler.min, @ruler.max)
    x: (@item_anchor_size * subindex + @options.marginLeft) * @real_width / 100
    y: (@options.marginTop + @drawable_height * factor_y) * @real_height / 100

  _drawDataset: (points, index, dataset) ->
    for point, subindex in points
      attributes =
        r   : 6
        cx  : "#{point.x}"
        cy  : "#{point.y}"
        class: "item index_#{index}"
      el = new UI.Element("circle", attributes)
      @_appendUIElement el
      @attachItemEvents el, dataset, subindex

  _drawSeparators: (points) ->
    for point in points
      @_appendUIElement new UI.Element "line",
        x1: point.x
        x2: point.x
        y1: "#{@options.marginTop}#{@units}"
        y2: "#{@options.marginTop + @drawable_height}#{@units}"
        class: "ruler"

  _drawItemLabel: (index, point) ->
    label = @data.labels[index]
    labelEl = new UI.Element "text",
      "x"           : point.x
      "y"           : "#{@height - @options.marginBottom / 2}#{@units}"
      "text-anchor" : "middle"
    labelEl.element.textContent = label
    @_appendUIElement labelEl

  _drawPath: (points, index) ->
    start_zero_x = @options.marginLeft * @real_width / 100
    zero_y = ((1 - @ruler.zero) * @drawable_height + @options.marginTop) * @real_height / 100
    end_zero_x = (@options.marginLeft + @drawable_width) * @real_width / 100
    pathDef = []
    if @fill_item
      pathDef.push "M #{start_zero_x} #{zero_y}"
      pathDef.push "L #{points[0].x},#{points[0].y}"
    else pathDef.push "M #{points[0].x},#{points[0].y}"

    num_points = points.length
    for i in [0..num_points - 2]
      xdiff = (points[i+1].x - points[i].x) * @options.bezierTension
      pathDef.push "C"
      pathDef.push "#{points[i].x + xdiff},#{points[i].y}"
      pathDef.push "#{points[i+1].x - xdiff},#{points[i+1].y}"
      pathDef.push "#{points[i+1].x},#{points[i+1].y}"

    if @fill_item then pathDef.push "L #{end_zero_x},#{zero_y}"
    path = new UI.Element "path",
      "class"           : "item index_#{index}"
      "d"               : pathDef.join(" ")
    @_appendUIElement path

  # Sets width of the bar
  _setItemAnchorSize: ->
    @item_anchor_size = @drawable_width / (@data.labels.length - 1)


class Chart.Line extends ChartLine
  constructor: (@container, options = {}) ->
    super
    @svg.setAttribute "data-svgchart-type", "line"
    @options.bezierTension = options.bezierTension or 0
    @fill_item = false

class Chart.Area extends ChartLine
  constructor: ->
    super
    @svg.setAttribute "data-svgchart-type", "area"
    @fill_item = true

class Chart.Point extends ChartLine
  constructor: ->
    super
    @svg.setAttribute "data-svgchart-type", "point"
    @fill_item = false
    @_drawPath = -> @
