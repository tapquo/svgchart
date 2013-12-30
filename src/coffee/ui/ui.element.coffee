class UI.Element

  constructor: (@type, @attributes) ->
    @element = document.createElementNS("http://www.w3.org/2000/svg", @type)
    @attr(attr, attributes[attr]) for attr of @attributes

  attr: (attribute, value) ->
    if value then @element.setAttribute attribute, value
    else return @element.getAttribute attribute

  append: (uiel) ->
    @element.appendChild uiel.element

  addClass: (className) ->
    current = @attr("class")
    unless current then @attr("class", className)
    else if current.split(" ").indexOf(className) is -1
      @attr "class", "#{current} #{className}"

  removeClass: (className) ->
    current = @attr("class")
    if current
      classes = current.split(" ")
      new_classes = classes.filter (cls) -> cls != className
      @attr "class", new_classes.join(" ")

  remove: ->
    if @element.parentNode
      @element.parentNode.removeChild(@element)

  bind: (eventName, callback) ->
    for ev in eventName.split(",")
      @element.addEventListener(ev, callback, true)
