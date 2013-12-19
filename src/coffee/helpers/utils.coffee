Utils =

  mergeOptions: (defaults, options = {}) ->
    merge = {}
    merge[key] = (if options[key] then options[key] else value) for key, value of defaults
    merge
