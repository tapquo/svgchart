class Base

  DEFAULT_OPTIONS =
    marginTop     : 0



    marginBottom  : 0
    marginLeft    : 0
    marginRight   : 0

  # Class constructor
  # Intializes common vars and appends svg element to container
  constructor: (@container, options = {}) ->
    @data = []
    @ui_elements = []
    @options = Utils.mergeOptions DEFAULT_OPTIONS, options
    do @_setWidthHeight
    do @_createSVG
    @tooltip = Tooltip(@container, @svg).init()

  # Sets chart data labels and values
  # @param data The data array of objects {label: '', value: 0}
  # example: [{label: '2012', value: 10}, {2013: '', value: 15}]
  setData: (@data) ->
    do @_setMaxMin
    if @max is 0 and @min is 0 then return false
    @num_datasets = if @data.dataset then @data.dataset.length else @data.length

  # Removes all created ui elements of the chart
  clear: ->
    ui.remove() for ui in @ui_elements
    @ui_elements = []

  # Draws the chart, This funcion is completed by chart-type draw function
  draw: ->
    do @_calcDrawableArea

  # ataches events to the ui element
  # @param uiel The UI Element node
  # @param dataset The item dataset
  # @param index Dataset index
  attachItemEvents: (uiel, dataset, index) ->
    uiel.bind "mouseover,touchstart", =>
      @tooltip.hide()
      @tooltip.html @tootipHTML(dataset, index)
      @tooltip.show()
      clearTimeout @tooltip_timeout
      @tooltip_timeout = setTimeout @tooltip.hide, 2000
    uiel.bind "mouseleave", (e) =>
      clearTimeout @tooltip_timeout
      @tooltip.hide()

  # Generates the tooltip element
  # @param data The item dataset
  # @param index Dataset index
  tootipHTML: (data, index) ->
    value = if data.values then data.values[index] else data.value
    """
    #{data.name}
    <h1>#{value}</h1>
    """

  onError: (callback) ->
    @error_callback = callback


  # Creates a svg element to append on it all UI elements
  _createSVG: ->
    @svg = document.createElementNS "http://www.w3.org/2000/svg", "svg"
    @svg.setAttribute "width", "100%"
    @svg.setAttribute "height", "100%"
    @container.appendChild @svg

  # Calcs drawable area width and height based on margins
  _calcDrawableArea: ->
    @drawable_width  = @width - @options.marginLeft - @options.marginRight
    @drawable_height = @height - @options.marginTop - @options.marginBottom

  # Appends an UI element to chart container
  # @param ui The UI element
  _appendUIElement: (ui) ->
    @ui_elements.push ui
    @svg.appendChild ui.element

  # Sets @max and @min based on values of @data
  _setMaxMin: ->
    vals = []
    if @data.dataset then vals = vals.concat(dataset.values) for dataset in @data.dataset
    else vals = vals.concat(dataset.value) for dataset in @data
    maxValue = if @options.maxValue then @options.maxValue else Maths.max(vals)
    @max = maxValue
    @min = Maths.min(vals)

  # Sets container width and heigth
  _setWidthHeight: ->
    @real_width = @container.offsetWidth
    @real_height = @container.offsetHeight
    @width = @container.offsetWidth
    @height = @container.offsetHeight

  #@TODO::Complete this function
  # Checks if data is valid
  _validData: ->
    true
