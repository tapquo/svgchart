class Core.Chart

  constructor: (@container) ->
    @data = []
    console.log @container
    @svgDoc = @container.contentDocument
    do @setTheme

  setData: (@data) -> @

  addData: (obj) ->
    @data.push(obj)

  appendUIElement: (el) ->

  setTheme: (@themeUrl = "themes/default.css") ->
    console.log @svgDoc
    style = document.createElementNS "http://www.w3.org/2000/svg", "style"
    style.textContent = "@import url(#{@themeUrl})"
    @container.appendChild style


  width: (@width) -> @
  height: (@height) -> @