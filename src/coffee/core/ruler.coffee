class Ruler

  DEFAULT_NUM_DIVISORS = 5
  DEFAULT_FONT_SIZE = 15

  constructor: (@options={}) ->
    @num_divisors   = @options.num_divisors or DEFAULT_NUM_DIVISORS
    @divisors       = []
    @min            = null
    @max            = null
    @zero_pos       = null

  setLimits: (@min, @max) ->
    if @min >= 0 then @min = 0
    else if @max < 0 then @max = 0
    do @_calcZero
    do @_calcDivisors

  _calcDivisors: ->
    delta = (@max - @min) / (@num_divisors - 1)
    for i in [0..@num_divisors - 1]
      @divisors.push parseFloat(@min + delta * i)

  _calcZero: ->
    if @min >= 0 then @zero = 0
    else if @max <= 0 then @zero = 1
    else @zero = Maths.rangeToPercent(0, @min, @max)



