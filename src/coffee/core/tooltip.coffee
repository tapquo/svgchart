Tooltip = (container, svg) ->

  _container  = container
  _svg        = svg
  _el         = null

  # Creates the tooltip HTML element on container
  init = ->
    _el = document.createElement "div"
    _el.setAttribute "data-svgchart-tooltip", "true"
    _container.appendChild _el
    @

  # Sets tooltip element text
  # @param text The text to show on tooltip
  text = (text) -> _el.innerText = text

  # Sets tooltip element html
  # @param html The HTML to show on tooltip
  html = (html) -> _el.innerHTML = html

  # Shows the tooltip and adds event listeners
  show = ->
    _el.classList.add "show"
    _container.addEventListener "mousemove", _onMove
    do _onMove

  # Hide the tooltip and removes event listeners
  hide = ->
    _el.classList.remove "show"
    _container.removeEventListener "mousemove", _onMove

  # Tooltip onMouseMove listener function
  _onMove = ->
    _el.style.top = "#{event.pageY - 20}px"
    _el.style.left = "#{event.pageX + 20}px"


  init: init
  text: text
  html: html
  show: show
  hide: hide
