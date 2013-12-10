Core.Element = do ->

  circle = (attributes) ->
    _create "circle", attributes

  semicircle = (attributes) ->
    _create "semicircle", attributes

  line = (attributes) ->
    _create "line", attributes

  bar = (attributes) ->
    _create "rect", attributes

  polyline = (attributes) ->
    _create "polyline", attributes

  _create = (el, data) ->
    el = document.createElementNS("http://www.w3.org/2000/svg", el)
    el.setAttribute(attribute, data[attribute]) for attribute of data
    return el

  # _create = (el, data) ->
  #   attributes = ("#{attribute}=\"#{data[attribute]}\"" for attribute of data)
  #   "<#{el} #{attributes.join(" ")} />"


  circle      : circle
  semicircle  : semicircle
  bar         : bar
  polyline    : polyline
