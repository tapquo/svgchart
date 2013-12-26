class Ruler

  DEFAULT_NUM_DIVISORS  = 6

  constructor: (@options = {}) ->
    @num_divisors   = @options.num_divisors or DEFAULT_NUM_DIVISORS
    @divisors       = []
    @axis           = "y"
    @min            = null
    @max            = null
    @zero_pos       = null

  # Sets the limits of the chart
  # @param min The min value of the chart
  # @param max The max value of the chart
  setLimits: (min, max) ->
    @min = Maths.min [min, max, 0]
    @max = Maths.max [min, max, 0]
    do @_calcZero
    do @_calcDivisors

  # Return real coords of all divisors for linear charts
  # @param height The height of the ruler
  # @param width The width of the ruler
  # @param margins Margins object
  setLinearCoords: (args...) ->
    @coords = {}
    @["_setLine#{@axis.toUpperCase()}Coords"].apply @, args

  # Return real coords of all divisors for linear charts for Y axis
  # @param height The height of the ruler
  # @param width The width of the ruler
  # @param margins Margins object
  _setLineYCoords: (height, width, margin=null) ->
    margin = margin or _getDefaultMargins()
    delta = height / (@divisors.length - 1)
    y = margin.top
    x1 = margin.left
    x2 = width + margin.left
    @coords.lines = []
    @coords.labels = []
    for value in @divisors.reverse()
      @coords.lines.push {x1:x1, x2:x2, y1:y, y2:y}
      @coords.labels.push {x:margin.left, y:y, label: value}
      y += delta

    # (1 - @zero) cause inverted coords of y axis n screens
    zeroY = (1 - @zero) * height + margin.top
    @coords.zero = x1:x1, x2:x2, y1:zeroY, y2:zeroY

  # Return real coords of all divisors for linear charts for X axis
  # @param height The height of the ruler
  # @param width The width of the ruler
  # @param margins Margins object
  _setLineXCoords: (height, width, margin=null) ->
    margin = margin or _getDefaultMargins()
    delta = width / (@divisors.length - 1)
    x = margin.left
    y1 = margin.top
    y2 = height + margin.top
    @coords.lines = []
    @coords.labels = []
    for value in @divisors
      @coords.lines.push {x1:x, x2:x, y1:y1, y2:y2}
      @coords.labels.push {x:x, y:y2, label: value}
      x += delta

    zeroX = @zero * width + margin.left
    @coords.zero = y1:y1, y2:y2, x1:zeroX, x2:zeroX

  # Crates divisors array with values.
  _calcDivisors: ->
    @divisors = []
    delta = (@max - @min) / (@num_divisors - 1)
    for i in [0..@num_divisors - 1]
      @divisors.push parseFloat(@min + delta * i)

  # Calcultes the 0 value position percent of the ruler
  _calcZero: ->
    if @min >= 0 then @zero = 0
    else if @max <= 0 then @zero = 1
    else @zero = Maths.rangeToPercent(0, @min, @max)

  # Calcultes the 0 value position percent of the ruler
  _getDefaultMargins = -> top: 0, right: 0, bottom: 0, left: 0

