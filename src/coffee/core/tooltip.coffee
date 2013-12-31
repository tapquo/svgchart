Tooltip = (container, svg) ->

  _container  = container
  _svg        = svg
  _el         = null

  init = ->
    _el = document.createElement "div"
    _el.setAttribute "data-svgchart-tooltip", "true"
    _container.appendChild _el
    @

  text = (text) -> _el.innerText = text

  html = (html) -> _el.innerHTML = html

  show = ->
    _el.classList.add "show"
    _container.addEventListener "mousemove", _onMove
    do _onMove

  hide = ->
    _el.classList.remove "show"
    _container.removeEventListener "mousemove", _onMove

  _onMove = ->
    _el.style.top = "#{event.pageY - 20}px"
    _el.style.left = "#{event.pageX + 20}px"

  init: init
  text: text
  html: html
  show: show
  hide: hide
