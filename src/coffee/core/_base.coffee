class Base

  constructor: (@container) ->
    @data = []
    @ui_elements = []
    @margins = top: 0, right: 0, bottom: 0, left: 0
    do @_createSVG
    @real_width = @svg.offsetWidth
    @real_height = @svg.offsetHeight

  # Overrides default margins
  setMargins: (top, right, bottom, left) ->
    @margins =
      top     : top or @margins.top
      right   : right or @margins.right
      bottom  : bottom or @margins.bottom
      left    : left or @margins.left

  # Sets chart title
  # @param title The title of the chart
  setTitle: (@title) -> @

  # Sets chart description
  # @param description The description of the chart
  setDescription: (@description) -> @

  # Sets chart data labels and values
  # @param data The data array of objects {label: '', value: 0}
  setData: (@data) -> @

  # Adds a value to the chart data
  # @param data Data object
  addData: (obj) -> @data.push(obj)

  # Removes all created ui elements of the chart
  clear: ->
    ui.remove() for ui in @ui_elements
    @ui_elements = []

  # Calcs drawable area width and height based on margins
  calcDrawableArea: ->
    @drawable_area_width  = @width - @margins.left - @margins.right
    @drawable_area_height = @height - @margins.top - @margins.bottom

  # Appends an UI element to chart container
  # @param ui The UI element
  appendUIElement: (ui) ->
    @ui_elements.push ui
    @svg.appendChild ui.element

  # Sets @max_value based on @data values
  _setMaxMin: () ->
    vals = (item.value for item in @data)
    @max_value = Maths.max(vals)
    @min_value = Maths.min(vals)

  # Sets a css url as theme and appends it to svg container
  setTheme: (@themeUrl) ->
    style = document.createElementNS "http://www.w3.org/2000/svg", "style"
    style.textContent = "@import url(#{@themeUrl})"
    @svg.appendChild style

  # Creates a svg element to append on it all UI or style elements
  _createSVG: ->
    @svg = document.createElementNS "http://www.w3.org/2000/svg", "svg"
    @svg.setAttribute "width", "100%"
    @svg.setAttribute "height", "100%"
    @container.appendChild @svg

