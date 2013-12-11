Maths =

  max: (vals) ->
    Math.max.apply Math, vals

  min: (vals) ->
    Math.min.apply Math, vals

  rangeToPercent: (number, min, max) ->
    (number - min) * 100 / (max - min)
