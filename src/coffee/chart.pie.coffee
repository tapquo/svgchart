class Chart.Pie extends Base.Angular

  # Sets data-svgchart-type to svg and creates ruler
  constructor: ->
    super
    @margins = top: 5, right: 5, bottom: 5, left: 5
    @width = 100
    @height = 100