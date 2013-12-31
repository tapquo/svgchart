Utils =

  mergeOptions: (default_options = {}, options = {}) ->
    default_options[key] = value for key, value of options
    default_options
