class Base

  constructor: (@container) ->
    @data = []
    @ui_elements = []
    do @_createSVG
    @width = @svg.offsetWidth
    @height = @svg.offsetHeight

  setTitle: (@title) -> @

  setDescription: (@description) -> @

  setData: (@data) -> @

  addData: (obj) -> @data.push(obj)

  removeAllUIElements: ->
    ui.element.remove() for ui in @ui_elements
    true

  appendUIElement: (ui) ->
    @ui_elements.push ui
    @svg.appendChild ui.element

  _setMaxMin: () ->
    vals = (item.value for item in @data)
    @max_value = Maths.max(vals)
    @min_value = Maths.min(vals)

  setTheme: (@themeUrl) ->
    style = document.createElementNS "http://www.w3.org/2000/svg", "style"
    style.textContent = "@import url(#{@themeUrl})"
    @svg.appendChild style

  _createSVG: ->
    @svg = document.createElementNS "http://www.w3.org/2000/svg", "svg"
    @svg.setAttribute "width", "100%"
    @svg.setAttribute "height", "100%"
    @container.appendChild @svg
