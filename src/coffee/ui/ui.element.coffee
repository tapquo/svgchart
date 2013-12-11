class UI.Element

  constructor: (@type, @attributes) ->
    @element = document.createElementNS("http://www.w3.org/2000/svg", @type)
    @element.setAttribute(attr, attributes[attr]) for attr of @attributes

  attr: (attribute, value) ->
    if value then @element.setAttribute attribute, value
    else return @element.getAttribute attribute

  class: (className) ->
    if className then @element.setAttribute "class", className
    else return @element.getAttribute "class"

