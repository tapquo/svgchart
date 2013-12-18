class Base.Linear extends Base

  # Define bars separation
  BARS_PADDING = 1

  # Sets data-svgchart-type to svg and creates ruler
  constructor: ->
    super
    @ruler = new Ruler()
    @margins = top: 0, right: 0, bottom: 0, left: 0
    @width = 100
    @height = 100

  # Draws all the chart
  draw: ->
    do @calcDrawableArea
    do @_setMaxMin
    do @_setItemAnchorSize
    @ruler.setLimits @min_value, @max_value
    do @drawDrawableContainer
    do @drawRulerDivisors
    for itemData, index in @data.slice(if @is_data_table then "1" else "0")
      @drawItem(itemData, index)

  # Calcs drawable area width and height based on margins
  calcDrawableArea: ->
    @drawable_area_width  = @width - @margins.left - @margins.right
    @drawable_area_height = @height - @margins.top - @margins.bottom

  # Draws a square for the drawable area with ruler styles
  drawDrawableContainer: ->
    uiel = new UI.Element.Bar("rect", {
      class   : "ruler"
      x       : "#{@margins.left}%"
      y       : "#{@margins.top}%"
      width   : "#{@drawable_area_width}%"
      height  : "#{@drawable_area_height}%"
    })
    @appendUIElement uiel

  # Draws a bar
  drawItem: (data, index) ->
    if @is_data_table
      console.log data
      for value, index2 in data
        factor_h = @calcItemH value
        factor_y = @calcItemY index, value, factor_h, index2
        factor_w = @calcItemW value
        factor_x = @calcItemX index, value, factor_w, index2
        attributes =
          x       : "#{@drawable_area_width * factor_x + @margins.left}%"
          y       : "#{@drawable_area_height * factor_y + @margins.top}%"
          width   : "#{@drawable_area_width * factor_w}%"
          height  : "#{@drawable_area_height * factor_h}%"

        console.debug attributes

        @appendBar attributes, data
        # @appendBarLabel(data.label, index)

    else
      value = data.value
      factor_h = @calcItemH value
      factor_y = @calcItemY index, value, factor_h
      factor_w = @calcItemW value
      factor_x = @calcItemX index, value, factor_w
      attributes =
        x       : "#{@drawable_area_width * factor_x + @margins.left}%"
        y       : "#{@drawable_area_height * factor_y + @margins.top}%"
        width   : "#{@drawable_area_width * factor_w}%"
        height  : "#{@drawable_area_height * factor_h}%"

      @appendBar attributes, data
      @appendBarLabel(data.label, index)

  # Creates bar UI element and appends it to container
  appendBar: (attributes, barData) ->
    attributes.class = "bar"
    uiel = new UI.Element.Bar "rect", attributes
    @attachItemEvents(uiel, barData)
    @appendUIElement uiel

  # # Appends bar bottom label
  appendBarLabel: (label, index) ->
    if @ruler.axis is "y"
      x = (@calcItemX(index) * @drawable_area_width + @margins.left + @item_anchor_size * 0.5) + "%"
      y = (@height - (@margins.bottom / 2)) + "%"
      text_anchor = "middle"
    else
      x = (@margins.left - 2) + "%"
      y = (@item_anchor_size * index) + @margins.top + @item_anchor_size / 2 + "%"
      text_anchor = "end"

    attributes = {
      x               : x
      y               : y
      "text-anchor"   : text_anchor
      "pointer-events": "none"
    }
    textElement = new UI.Element "text", attributes
    textElement.element.textContent = label
    @appendUIElement textElement


  # Draws ruler labels
  drawRuleLabels: ->
    for value, i in @ruler.divisors
      attributes =
        "pointer-events"  : "none"
        "class"           : "ruler_label"

      if @ruler.axis is "y"
        attributes.x = "#{@margins.left - 1}%"
        attributes.y = "#{@ruler.coords[i].y1 + 1}%"
        attributes['text-anchor'] = "end"
      else
        attributes.x = "#{@ruler.coords[i].x1}%"
        attributes.y = "#{@margins.top + @drawable_area_height + 2}%"
        attributes['text-anchor'] = "middle"

      textElement = new UI.Element "text", attributes
      textElement.element.textContent = value.toFixed(2)
      @appendUIElement textElement


  # Ruler draw functions
  drawRulerDivisors: ->
    height = @drawable_area_height
    width = @drawable_area_width
    @ruler.setLinearCoords height, width, @margins
    do @drawRuleLabels
    @drawRuleLine coords for coords in @ruler.coords
    @drawRuleLine @ruler.zero_coords, true

  drawRuleLine: (coords, isZero=false) ->
    zeroClass = if isZero then " zero" else ""
    line = new UI.Element "line",
      x1    : "#{coords.x1}%"
      x2    : "#{coords.x2}%"
      y1    : "#{coords.y1}%"
      y2    : "#{coords.y2}%"
      class : "ruler#{zeroClass}"
    @appendUIElement line
