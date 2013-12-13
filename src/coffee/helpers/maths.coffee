Maths =

  # Returns the max number of numbers array.
  # @param [vals]
  max: (vals) ->
    Math.max.apply Math, vals

  # Returns the min number of numbers array.
  # @param [vals]
  min: (vals) ->
    Math.min.apply Math, vals

  # Returns the percentage of a number in a given range.
  # Example: num = 15 range 10 to 20 // outputs 0.5
  # @param num
  # @param range_min
  # @param range_max
  rangeToPercent: (number, range_min, range_max, constrain_min = false, constrain_max = false) ->
    if constrain_min and number < range_min then 0
    else if constrain_max and number > range_max then 1
    else (number - range_min) / (range_max - range_min)

  # Returns the number that corresponds to the percentage in a given range.
  # Example: percent = 0.5 range 10 to 20 // outputs 15
  # @param percent
  # @param range_min
  # @param range_max
  percentToRange: (percent, range_min, range_max) ->
   (range_max - range_min) * percent + range_min

  # Converts radians to degrees.
  # @param radians
  radiansToDegrees: (radians) ->
    radians * 180 / Math.PI

  # Converts degrees to radians.
  # @param degrees
  degreesToRadians: (degrees) ->
    degrees * Math.PI / 180

  # Returns 1 if the value is >= 0. Returns -1 if the value is < 0.
  # @param  num
  sign: (num) ->
    if num < 0 then -1 else 1

  # Returns a number constrained between min and max.
  # @param num
  # @param min
  # @param max
  constrain: (num, min=0, max=1) ->
    if num < min then min
    if num > max then max
    num

  # Returns a random number between min and max.
  # @param min
  # @param max
  randomRange: (min, max, round=false) ->
    num = min + Math.random() * (max - min)
    if round then Math.round(num) else num

  # Re-maps a number from one range to another. The output is the same as inputing the result of rangeToPercent() into percentToRange().
  # Example: num = 10, min1 = 0, max1 = 100, min2 = 0, max2 = 50 // outputs 5
  # @param num
  # @param min1
  # @param max1
  # @param min2
  # @param max2
  map: (num, min1, max1, min2, max2, round=false) ->
    num1 = (num - min1) / (max1 - min1)
    num2 = num1 * (max2 - min2) + min2
    if round then Math.round(num2) else num2

