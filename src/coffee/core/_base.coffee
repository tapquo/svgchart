class Base

  constructor: (@container) ->
    @data = []
    @ui_elements = []
    do @_createSVG
    @width = @svg.offsetWidth
    @height = @svg.offsetHeight

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
  removeAllUIElements: ->
    ui.remove() for ui in @ui_elements
    @ui_elements = []

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
