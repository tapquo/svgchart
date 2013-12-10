class Chart.Bar extends Core.Chart

  setMax: (data) ->
    @max = 0
    @max = item.value for item in data when item.value > @max

  _drawItem = (data) ->
    label = data.label
    value = data.value

  draw: ->
    @setMax(@data)
    _drawItem(bar) for bar in @data


Helper = {

    UI: {

        circle: () ->

        box: () ->
        semicircle: () ->
        polyline: () ->


    }
}
