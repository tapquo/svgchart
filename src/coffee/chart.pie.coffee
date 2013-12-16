class Chart.Pie extends Base.Angular

  # Sets data-svgchart-type to svg and creates ruler
  constructor: ->
    super
    @svg.setAttribute "data-svgchart-type", "pie"
    @margins = top: 5, right: 5, bottom: 5, left: 5
    @width = 100
    @height = 100