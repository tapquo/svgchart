class Base

  # Class constructor
  # Intializes common vars and appends svg element to container
  constructor: (@container, options = {}) ->
    @data = []
    @ui_elements = []
    @margins = top: 0, right: 0, bottom: 0, left: 0
    do @_setWidthHeight
    do @_calcDrawableArea
    do @_createSVG
    Tooltip.init @container, @svg

  # Sets drawable area margins in percent
  # @param top Top margin
  # @param right Right margin
  # @param bottom Bottom margin
  # @param left Left margin
  setMargins: (top, right, bottom, left) ->
    @margins =
      top     : top or @margins.top
      right   : right or @margins.right
      bottom  : bottom or @margins.bottom
      left    : left or @margins.left
    do @_calcDrawableArea

  # Sets chart title
  # @param title The title of the chart
  setTitle: (@title) -> @

  # Sets chart description
  # @param description The description of the chart
  setDescription: (@description) -> @

  # Sets chart data labels and values
  # @param data The data array of objects {label: '', value: 0}
  # example: [{label: '2012', value: 10}, {2013: '', value: 15}]
  setData: (@data) ->
    do @_setMaxMin
    @num_datasets = if @data.dataset then @data.dataset.length else @data.length

  # Removes all created ui elements of the chart
  clear: ->
    ui.remove() for ui in @ui_elements
    @ui_elements = []

  draw: ->
    do @_calcDrawableArea

  # Calcs drawable area width and height based on margins
  _calcDrawableArea: ->
    @drawable_width  = @width - @margins.left - @margins.right
    @drawable_height = @height - @margins.top - @margins.bottom

  # Appends an UI element to chart container
  # @param ui The UI element
  _appendUIElement: (ui) ->
    @ui_elements.push ui
    @svg.appendChild ui.element

  # Sets @max and @min based on @data
  _setMaxMin: () ->
    vals = []
    if @data.dataset then vals = vals.concat(dataset.values) for dataset in @data.dataset
    else vals = vals.concat(dataset.value) for dataset in @data
    @max = Maths.max(vals)
    @min = Maths.min(vals)

  # Sets container width and heigth
  _setWidthHeight: ->
    @real_width = @container.offsetWidth
    @real_height = @container.offsetHeight
    @width = @container.offsetWidth
    @height = @container.offsetHeight

  # Checks if data is valid
  _validData: ->
    true

  # Creates a svg element to append on it all UI elements
  _createSVG: ->
    @svg = document.createElementNS "http://www.w3.org/2000/svg", "svg"
    @svg.setAttribute "width", "100%"
    @svg.setAttribute "height", "100%"
    @container.appendChild @svg

