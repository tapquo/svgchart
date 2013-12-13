class Ruler

  DEFAULT_NUM_DIVISORS = 5

  DEFAULT_MARGINS = {}

  constructor: (@options={}) ->
    @num_divisors   = @options.num_divisors or DEFAULT_NUM_DIVISORS
    @divisors       = []
    @min            = null
    @max            = null
    @zero_pos       = null

  # Sets the limits of the chart
  # @param min The min value of the chart
  # @param max The max value of the chart
  setLimits: (@min, @max) ->
    if @min >= 0 then @min = 0
    else if @max < 0 then @max = 0
    do @_calcZero
    do @_calcDivisors

  # Return real coords of all divisors for linear charts
  # @param height The height of the ruler
  # @param width The width of the ruler
  # @axis The divisor axis to paint
  # @param mt Margin top
  # @param mr Margin right
  # @param mb Margin bottom
  # @param ml Margin left
  getLinearCoords: (height, width, axis="y", margin=null) ->
    margin = margin or {
      top     : 0
      right   : 0
      bottom  : 0
      left    : 0
    }
    delta = height / (@divisors.length - 1)
    y = margin.top
    x1 = margin.left
    x2 = width + margin.left
    posis = []
    for value in @divisors.reverse()
      posis.push {x1:x1, x2:x2, y1:y, y2:y}
      y += delta
    posis

  # Crates divisors array with values.
  _calcDivisors: ->
    delta = (@max - @min) / (@num_divisors - 1)
    for i in [0..@num_divisors - 1]
      @divisors.push parseFloat(@min + delta * i)

  # Calcultes the 0 value position percent of the ruler
  _calcZero: ->
    if @min >= 0 then @zero = 0
    else if @max <= 0 then @zero = 1
    else @zero = Maths.rangeToPercent(0, @min, @max)
