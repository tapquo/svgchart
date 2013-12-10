class Core.Chart

  constructor: (@container) ->
    @data = []
    @svgDoc = @container.contentDocument

  setData: (@data) -> @

  addData: (obj) -> @data.push(obj)

  appendUIElement: (el) ->
    @container.appendChild(el)

  setTheme: (@themeUrl) ->
    style = document.createElementNS "http://www.w3.org/2000/svg", "style"
    style.textContent = "@import url(#{@themeUrl})"
    @container.appendChild style


  width: (@width) -> @
  height: (@height) -> @