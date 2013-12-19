Tooltip = do ->

  _container  = null
  _el         = null
  _svg        = null
  _svgPoint   = null

  init = (container, svg) ->
    _container = container
    _svg = svg
    _el = document.createElement "div"
    _el.setAttribute "data-svgchart-tooltip", "true"
    _container.appendChild _el
    _svgPoint = _svg.createSVGPoint()

  text = (text) -> _el.innerText = text

  html = (html) -> _el.innerHTML = html

  show = ->
    _el.classList.add "show"
    _container.addEventListener "mousemove", _onMove

  hide = ->
    _el.classList.remove "show"
    _container.removeEventListener "mousemove", _onMove

  _onMove = (e) ->
    _el.style.top = "#{e.y - 20}px"
    _el.style.left = "#{e.x + 20}px"

  init: init
  text: text
  html: html
  show: show
  hide: hide
