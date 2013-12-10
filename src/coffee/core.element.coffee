Core.Element = do ->


  circle = (attributes) ->
    _create "circle", attributes

  semicircle = (attributes) ->
    _create "semicircle", attributes

  bar = (attributes) ->
    _create "bar", attributes

  polyline = (attributes) ->
    _create "polyline", attributes

  _create = (el, data) ->





  circle      : circle
  semicircle  : semicircle
  bar         : bar
  polyline    : polyline
