class Base

  constructor: (@container) ->
    @data = []
    @ui_elements = []
    @svgDoc = @container.contentDocument

  setData: (@data) -> @

  addData: (obj) -> @data.push(obj)

  removeAllUIElements: ->
    ui.element.remove() for ui in @ui_elements
    true

  appendUIElement: (ui) ->
    @ui_elements.push ui
    @container.appendChild ui.element

  setTheme: (@themeUrl) ->
    style = document.createElementNS "http://www.w3.org/2000/svg", "style"
    style.textContent = "@import url(#{@themeUrl})"
    @container.appendChild style


  width: (@width) -> @
  height: (@height) -> @