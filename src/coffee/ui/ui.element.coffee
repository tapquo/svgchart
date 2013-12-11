class UI.Element

  constructor: (@type, @attributes) ->
    @element = document.createElementNS("http://www.w3.org/2000/svg", @type)
    @element.setAttribute(attr, attributes[attr]) for attr of @attributes

