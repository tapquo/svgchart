class Chart.Bar extends Core.Chart

  setMax: (data) ->
    @max = 0
    @max = item.value for item in data when item.value > @max

  calcBarWidth: ->
    @barWidth = @container.getAttribute("width") / @data.length
    console.log @barWidth

  _drawItem: (data) ->
    label = data.label
    value = data.value

    el = Core.Element.bar({
      width: 20,
      height: 20,
      x: 100,
      y: 100,
      fill: "red"
    })

    el2 = Core.Element.bar({
      width: 20,
      height: 20,
      x: 10,
      y: 10,
      fill: "blue"
      style: ""
    })
    @appendUIElement el
    @appendUIElement el2

  draw: ->
    @setMax(@data)
    @calcBarWidth()
    current = 0
    for i, bar in @data
      console.log(i)
      @_drawItem(bar)
