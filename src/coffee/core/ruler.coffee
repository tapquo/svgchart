class Ruler

  DEFAULT_NUM_DIVISORS  = 14

  constructor: (@options={}) ->
    @num_divisors   = @options.num_divisors or DEFAULT_NUM_DIVISORS
    @divisors       = []
    @axis           = "y"
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
  # @param margins Margins object
  setLinearCoords: (args...) ->
    @["set#{@axis.toUpperCase()}Coords"].apply @, args

  # Return real coords of all divisors for linear charts for Y axis
  # @param height The height of the ruler
  # @param width The width of the ruler
  # @param margins Margins object
  setYCoords: (height, width, margin=null) ->
    margin = margin or _getDefaultMargins()
    delta = height / (@divisors.length - 1)
    y = margin.top
    x1 = margin.left
    x2 = width + margin.left
    @coords = []
    for value in @divisors.reverse()
      @coords.push {x1:x1, x2:x2, y1:y, y2:y}
      y += delta

    zeroY = @zero * height + margin.top
    @zero_coords = x1:x1, x2:x2, y1:zeroY, y2:zeroY


  # Return real coords of all divisors for linear charts for X axis
  # @param height The height of the ruler
  # @param width The width of the ruler
  # @param margins Margins object
  setXCoords: (height, width, margin=null) ->
    margin = margin or _getDefaultMargins()
    delta = width / (@divisors.length - 1)
    x = margin.left
    y1 = margin.top
    y2 = height + margin.top
    @coords = []
    for value in @divisors
      @coords.push {x1:x, x2:x, y1:y1, y2:y2}
      x += delta
    zeroX = @zero * width + margin.left
    @zero_coords = y1:y1, y2:y2, x1:zeroX, x2:zeroX


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

  _getDefaultMargins = -> top: 0, right: 0, bottom: 0, left: 0

