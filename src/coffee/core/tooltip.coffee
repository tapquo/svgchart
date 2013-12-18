do ->


  # document.querySelector("[data-tooltip]").addEventListener "mouseover", (e) ->
  #   console.log "Overrrrrrr"

  # constructor: (@svg, @item, @label="", @value=null) ->
  #   @point = @svg.createSVGPoint()
  #   @item.element.addEventListener "mousemove", @_mouseOver
  #   @item.element.addEventListener "mouseleave", @_mouseLeave
  #   @uiel = new UI.Element("text", {x: -50, y: -50})
  #   @uiel.element.textContent = @label
  #   @svg.appendChild @uiel.element

  # cursorPoint: (evt) ->
  #   @point.x = evt.clientX
  #   @point.y = evt.clientY
  #   @point.matrixTransform @svg.getScreenCTM()

  # _mouseOver: (evt) =>
  #   pos = @cursorPoint(evt)
  #   @uiel.attr "x", pos.x
  #   @uiel.attr "y", pos.y
  #   console.log pos.x, pos.y, @label, @value

